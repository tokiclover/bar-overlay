# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/aufs2/aufs2-0_p20110327.ebuild,v 1.1 2011/03/27 13:09:40 jlec Exp $

EAPI="4"

inherit linux-mod multilib toolchain-funcs git-2

DESCRIPTION="An entirely re-designed and re-implemented Unionfs"
HOMEPAGE="http://aufs.sourceforge.net/"
EGIT_REPO_URI="git://aufs.git.sourceforge.net/gitroot/aufs/aufs2-standalone.git"
EGIT_NONBARE=yes
EGIT_PROJECT=${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug fuse hardened hfs inotify kernel-patch nfs ramfs"

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
	kernel_is gt 3 0 1 && die "kernel too new"
	kernel_is ge 3 0 0 && EGIT_BRANCH=aufs2.1 || EGIT_BRANCH=aufs2.1-${KV_PATCH}

	linux-mod_pkg_setup
	if ! ( patch -p1 --dry-run --force -R -d ${KV_DIR} < "${FILESDIR}"/aufs2-standalone-${KV_PATCH}.patch >/dev/null && \
		patch -p1 --dry-run --force -R -d ${KV_DIR} < "${FILESDIR}"/aufs2-base.patch >/dev/null ); then
		if use kernel-patch; then
			cd ${KV_DIR}
			ewarn "Patching your kernel..."
			patch --no-backup-if-mismatch --force -p1 -R -d ${KV_DIR} < "${FILESDIR}"/aufs2-standalone-${KV_PATCH}.patch >/dev/null
			patch --no-backup-if-mismatch --force -p1 -R -d ${KV_DIR} < "${FILESDIR}"/aufs2-base-${KV_PATCH}.patch >/dev/null
			epatch "${FILESDIR}"/aufs2-{base,standalone}-${KV_PATCH}.patch
			ewarn "You need to compile your kernel with the applied patch"
			ewarn "to be able to load and use the aufs kernel module"
		else
			eerror "You need to apply a patch to your kernel to compile and run the aufs2 module"
			eerror "Either enable the kernel-patch useflag to do it with this ebuild"
			eerror "or apply 'patch -p1 < ${FILESDIR}/aufs2-base.patch' and"
			eerror "'patch -p1 < ${FILESDIR}/aufs2-standalone.patch' by hand"
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

	use hardened && epatch "${FILESDIR}"/pax.patch

	sed -i "s:aufs.ko usr/include/linux/aufs_type.h:aufs.ko:g" Makefile || die "eek!"
	sed -i "s:__user::g" include/linux/aufs_type.h || die "eek!"
}

src_compile() {
	local ARCH=x86
	emake CC=$(tc-getCC) CONFIG_AUFS_FS=m KDIR=${KV_DIR}
}

src_install() {
	linux-mod_src_install
	insinto /usr/include/linux
	doins include/linux/aufs_type.h || die "failed to install header."
	dodoc README
	docinto design
	dodoc design/*.txt
}
