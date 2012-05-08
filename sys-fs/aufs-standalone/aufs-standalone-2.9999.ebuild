# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-fs/aufs-standalone/aufs-standalone-2.9999.ebuild v1.4 2012/05/08 -tclover Exp $

EAPI="4"

inherit linux-mod multilib toolchain-funcs git-2

DESCRIPTION="An entirely re-designed and re-implemented Unionfs"
HOMEPAGE="http://aufs.sourceforge.net/"
EGIT_NONBARE=yes
EGIT_PROJECT=${PN/-/2-}.git
EGIT_REPO_URI="git://aufs.git.sourceforge.net/gitroot/aufs/aufs2-standalone.git"
EGIT_NONBARE=yes
RDEPEND="!sys-fs/aufs2
		=sys-fs/${P/standalone/util}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug fuse header hfs inotify kernel-patch nfs pax_kernel ramfs"

S="${WORKDIR}"/${PN}

MODULE_NAMES="aufs(misc:${S})"

pkg_setup() {
	CONFIG_CHECK="${CONFIG_CHECK} ~EXPERIMENTAL"
	use inotify && CONFIG_CHECK="${CONFIG_CHECK} ~FSNOTIFY"
	use nfs && CONFIG_CHECK="${CONFIG_CHECK} ~EXPORTFS"
	use fuse && CONFIG_CHECK="${CONFIG_CHECK} ~FUSE_FS"
	use hfs && CONFIG_CHECK="${CONFIG_CHECK} ~HFSPLUS_FS"

	# this is needed so merging a binpkg aufs2 is possible
	# w/out a kernel unpacked on the system
	[ -n "$PKG_SETUP_HAS_BEEN_RAN" ] && return

	get_version
	kernel_is lt 2 6 31 && die "kernel too old"
	kernel_is lt 2 6 35 && ewarn "there's no support for kernel <v2.6.35 as of 2011-08-15"
	if [ ${KV_MAJOR} -eq 3 ]; then VERSION=${KV_MAJOR}.0
	elif [ ${KV_MAJOR} -eq 2 ]; then
		if [ ${KV_PATCH} -lt 35 ]; then VERSION=${KV_MAJOR}.1-${KV_PATCH}
		else VERSION=${KV_MAJOR}.2-${KV_PATCH}; fi
	fi
	EGIT_BRANCH=aufs${VERSION}
	[ "${KV_FULL/_rc}" != "${KV_FULL}" ] && EGIT_BRANCH=aufs${KV_MAJOR}.x-rcN
	
	linux-mod_pkg_setup
	if ! ( patch -p1 --dry-run --force -R -d ${KV_DIR} \
		   < "${FILESDIR}"/aufs-standalone-${VERSION}.patch >/dev/null && \
		patch -p1 --dry-run --force -R -d ${KV_DIR} \
			< "${FILESDIR}"/aufs-base-${VERSION}.patch >/dev/null ); then
		if use kernel-patch; then
			cd ${KV_DIR}
			ewarn "Patching your kernel..."
			patch --no-backup-if-mismatch --force -p1 -R -d ${KV_DIR} \
				< "${FILESDIR}"/aufs-standalone-${VERSION}.patch >/dev/null
			patch --no-backup-if-mismatch --force -p1 -R -d ${KV_DIR} \
				< "${FILESDIR}"/aufs-base-${VERSION}.patch >/dev/null
			epatch "${FILESDIR}"/aufs-{base${PROC_MAP},standalone}-${VERSION}.patch
			ewarn "You need to compile your kernel with the applied patch"
			ewarn "to be able to load and use the aufs kernel module"
		else
			eerror "Apply patches to your kernel to compile and run the aufs${KV_MAJOR} module"
			eerror "Either enable the kernel-patch useflag to do it with this ebuild"
			eerror "or apply 'patch -p1 < ${FILESDIR}/aufs-base-${VERSION}.patch' and"
			eerror "'patch -p1 < ${FILESDIR}/aufs-standalone-${VERSION}.patch' by hand"
			die "missing kernel patch, please apply it first"
		fi
	fi
	export PKG_SETUP_HAS_BEEN_RAN=1
}

set_config() {
	for option in $*; do
		grep -q "^CONFIG_AUFS_${option} =" config.mk || \
			die "${option} is not a valid config option"
		sed -e "/^CONFIG_AUFS_${option}/s:=:= y:g" -i config.mk || die "eek!"
	done
}

src_prepare() {
	# All config options to off
	sed -e 's:= y:=:g' -i config.mk || die "eek!"

	set_config RDU BRANCH_MAX_127 SBILIST

	use debug && set_config DEBUG
	use fuse && set_config BR_FUSE POLL
	use hfs && set_config BR_HFSPLUS
	use inotify && set_config HNOTIFY HFSNOTIFY
	use nfs && set_config EXPORT
	use nfs && use amd64 && set_config INO_T_64
	use ramfs && set_config BR_RAMFS

	use pax_kernel && epatch "${FILESDIR}"/pax.patch

	sed -e 's:aufs.ko usr/include/linux/aufs_type.h:aufs.ko:g' -i Makefile || die "eek!"
	sed -e 's:__user::g' -i include/linux/aufs_type.h || die "eek!"
	sed -e "s:/lib/modules/\$(shell uname -r)/build:${KV_OUT_DIR}:g" -i Makefile || die "eek!"
}

src_compile() {
	local ARCH=x86
	emake CC=$(tc-getCC) CONFIG_AUFS_FS=m KDIR=${KV_DIR}
}

src_install() {
	linux-mod_src_install
	insinto /usr/include/linux
	use header && doins include/linux/aufs_type.h || die "failed to install header."
#	use header && emake DESTDIR="${D}" install_header || die "eek!"
	dodoc README
	docinto design
	dodoc design/*.txt
}
