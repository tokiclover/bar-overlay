# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-fs/aufs-standalone/aufs-standalone-3.9999.ebuild v1.5 2012/06/23 11:45:21 -tclover Exp $

EAPI=4

inherit linux-mod multilib toolchain-funcs git-2

DESCRIPTION="An entirely re-designed and re-implemented Unionfs"
HOMEPAGE="http://aufs.sourceforge.net/"
EGIT_PROJECT=${PN/-/3-}.git
EGIT_REPO_URI="git://aufs.git.sourceforge.net/gitroot/aufs/aufs3-standalone.git"
EGIT_NONBARE=yes

RDEPEND="!sys-fs/aufs3
	=sys-fs/${P/standalone/utils}
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc fuse pax_kernel header hfs inotify kernel-patch nfs ramfs"

S="${WORKDIR}"/${PN}

MODULE_NAMES="aufs(misc:${S})"

pkg_setup() {
	CONFIG_CHECK="${CONFIG_CHECK} ~EXPERIMENTAL"
	use inotify && CONFIG_CHECK="${CONFIG_CHECK} ~FSNOTIFY"
	use nfs && CONFIG_CHECK="${CONFIG_CHECK} ~EXPORTFS"
	use fuse && CONFIG_CHECK="${CONFIG_CHECK} ~FUSE_FS"
	use hfs && CONFIG_CHECK="${CONFIG_CHECK} ~HFSPLUS_FS"

	# this is needed so merging a binpkg aufs-standalone is possible
	# w/out a kernel unpacked on the system
	[ -n "$PKG_SETUP_HAS_BEEN_RAN" ] && return

	get_version

	kernel_is lt 3 0 0 && die "kernel too old"
	[[ "${CKV}" != "${OKV}" ]] && local version=${KV_MAJOR}.x-rcN ||
		local version=${KV_MAJOR}.${KV_MINOR}
	EGIT_BRANCH=aufs${version}	

	linux-mod_pkg_setup
	if ! ( pushd ${KV_DIR}
		for patch in proc_map standalone base; do
			bzip2 -dc "${FILESDIR}"/aufs-${patch}-${version}.patch.bz2 | \
			patch -p1 --dry-run --force -R >/dev/null || { break && return 1; }
		done ); then
		if use kernel-patch; then
			ewarn "Patching your kernel..."
			for patch in proc_map standalone base; do
				bzip2 -dc "${FILESDIR}"/aufs-proc_map-${version}.patch.bz2 | \
				patch --no-backup-if-mismatch --force -p1 -R >/dev/null
			done
			popd
			epatch "${FILESDIR}"/aufs-{base,standalone,proc_map}-${version}.patch.bz2
			ewarn "You need to compile your kernel with the applied patch"
			ewarn "to be able to load and use the aufs kernel module"
		else
			eerror "Apply patches to your kernel to compile and run the aufs${KV_MAJOR} module"
			eerror "Either enable the kernel-patch useflag to do it with this ebuild"
			eerror "or apply 'bzip2 -dc ${FILESDIR}/aufs-base-${version}.patch.bz2 | patch -p1'"
			eerror "and 'bzip2 -dc ${FILESDIR}/aufs-standalone-${version}.patch.bz2 | patch -p1'"
			eerror "and 'bzip2 -dc ${FILESDIR}/aufs-proc_map-${version}.patch.bz2 | patch -p1'"
			die "missing kernel patch, please apply it first"
		fi
	fi
	export PKG_SETUP_HAS_BEEN_RAN=1
}

set_config() {
	for option in $*; do
		grep -q "^CONFIG_AUFS_${option} =" config.mk ||
			die "${option} is not a valid config option"
		sed -e "/^CONFIG_AUFS_${option}/s:=:= y:g" -i config.mk || die
	done
}

src_prepare() {
	# All config options to off
	sed -e 's:= y:=:g' -i config.mk || die

	set_config RDU BRANCH_MAX_127 SBILIST

	use debug && set_config DEBUG
	use fuse && set_config BR_FUSE POLL
	use hfs && set_config BR_HFSPLUS
	use inotify && set_config HNOTIFY HFSNOTIFY
	use nfs && set_config EXPORT
	use nfs && use amd64 && set_config INO_T_64
	use ramfs && set_config BR_RAMFS

	use pax_kernel && epatch "${FILESDIR}"/pax.patch.bz2

	sed -e 's:aufs.ko usr/include/linux/aufs_type.h:aufs.ko:g' -i Makefile || die
	sed -e 's:__user::g' -i include/linux/aufs_type.h || die
	sed -e "s:/lib/modules/\$(shell uname -r)/build:${KV_OUT_DIR}:g" -i Makefile || die
}

src_compile() {
	local ARCH=x86
	emake CC=$(tc-getCC) CONFIG_AUFS_FS=m KDIR=${KV_DIR}
}

src_install() {
	export KV_OBJ=ko
	linux-mod_src_install
	use header && emake DESTDIR="${D}" install_header
	dodoc README
	docinto design
	dodoc design/*.txt
}
