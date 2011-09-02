# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/sys-fs/aufs2/aufs2-0_p20110327.ebuild, v1.3 2011/08/17 Exp $

EAPI="4"

inherit linux-mod multilib toolchain-funcs git-2

DESCRIPTION="An entirely re-designed and re-implemented Unionfs"
HOMEPAGE="http://aufs.sourceforge.net/"
EGIT_NONBARE=yes

get_version

if [ ${KV_MAJOR} -eq 3 ]; then
	[ ${PV/_rc} = ${PV} ] && EGIT_BRANCH=aufs${KV_MAJOR}.${KV_MINOR} || \
		EGIT_BRANCH=aufs${KV_MAJOR}.x-rcN
elif [ ${KV_MAJOR} -eq 2 ]; then
	if [ ${KV_PATCH} -lt 35 ]; then
		EGIT_BRANCH=aufs${KV_MAJOR}.1-${KV_PATCH}
		VERSION=${KV_MAJOR}.1-${KV_PATCH}
	else
		EGIT_BRANCH=aufs${KV_MAJOR}.2-${KV_PATCH}
		VERSION=${KV_MAJOR}.2-${KV_PATCH}; fi
fi

EGIT_PROJECT=${PN/-/${KV_MAJOR}-}
EGIT_REPO_URI="git://aufs.git.sourceforge.net/gitroot/aufs/aufs${KV_MAJOR}-standalone.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug fuse header hfs inotify kernel-patch nfs pax_kernel ramfs"

RDEPEND="!sys-fs/aufs2
		=sys-fs/${P/standalone/util}"

S="${WORKDIR}"/${PN}

MODULE_NAMES="aufs(misc:${S})"

pkg_setup() {
	CONFIG_CHECK="${CONFIG_CHECK} ~EXPERIMENTAL"
	use inotify && CONFIG_CHECK="${CONFIG_CHECK} ~FSNOTIFY"
	use nfs && CONFIG_CHECK="${CONFIG_CHECK} ~EXPORTFS"
	use fuse && CONFIG_CHECK="${CONFIG_CHECK} ~FUSE_FS"
	use hfs && CONFIG_CHECK="${CONFIG_CHECK} ~HFSPLUS_FS"

	# this is needed so merging a binpkg aufs2 is possible w/out a kernel unpacked on the system
	[ -n "$PKG_SETUP_HAS_BEEN_RAN" ] && return

	get_version
	kernel_is lt 2 6 31 && die "kernel too old"
	kernel_is lt 2 6 35 && ewarn "there's no support for kernel <v2.6.35 as of 2011-08-15, upgrde to kernel >v2.6.34"
	kernel_is gt 3 1 	&& die "kernel too new"

	linux-mod_pkg_setup
	if ! ( patch -p1 --dry-run --force -R -d ${KV_DIR} < "${FILESDIR}"/aufs-standalone-${VERSION}.patch >/dev/null && \
		patch -p1 --dry-run --force -R -d ${KV_DIR} < "${FILESDIR}"/aufs-base-${VERSION}.patch >/dev/null ); then
		if use kernel-patch; then
			cd ${KV_DIR}
			ewarn "Patching your kernel..."
			patch --no-backup-if-mismatch --force -p1 -R -d ${KV_DIR} < "${FILESDIR}"/aufs-standalone-${VERSION}.patch >/dev/null
			patch --no-backup-if-mismatch --force -p1 -R -d ${KV_DIR} < "${FILESDIR}"/aufs-base-${VERSION}.patch >/dev/null
			epatch "${FILESDIR}"/aufs-{base${PROC_MAP},standalone}-${VERSION}.patch
			ewarn "You need to compile your kernel with the applied patch"
			ewarn "to be able to load and use the aufs kernel module"
		else
			eerror "You need to apply a patch to your kernel to compile and run the aufs${KV_MAJOR} module"
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
		grep -q "^CONFIG_AUFS_${option} =" config.mk || die "${option} is not a valid config option"
		sed "/^CONFIG_AUFS_${option}/s:=:= y:g" -i config.mk || die "eek!"
	done
}

src_prepare() {
	# All config options to off
	sed "s:= y:=:g" -i config.mk || die "eek!"

	set_config RDU BRANCH_MAX_127 SBILIST

	use debug && set_config DEBUG
	use fuse && set_config BR_FUSE POLL
	use hfs && set_config BR_HFSPLUS
	use inotify && set_config HNOTIFY HFSNOTIFY
	use nfs && set_config EXPORT
	use nfs && use amd64 && set_config INO_T_64
	use ramfs && set_config BR_RAMFS

	use pax_kernel && epatch "${FILESDIR}"/pax.patch

	sed -i "s:aufs.ko usr/include/linux/aufs_type.h:aufs.ko:g" Makefile || die "eek!"
	sed -i "s:__user::g" include/linux/aufs_type.h || die "eek!"
	sed -i "s:/lib/modules/\$(shell uname -r)/build:${KV_OUT_DIR}:g" Makefile || die "eek!"
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
