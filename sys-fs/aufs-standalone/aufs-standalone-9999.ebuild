# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-fs/aufs-standalone/aufs-standalone-9999.ebuild v1.6 2012/07/31 23:23:44 -tclover Exp $

EAPI=4

inherit linux-mod multilib toolchain-funcs git-2

DESCRIPTION="An entirely re-designed and re-implemented Unionfs"
HOMEPAGE="http://aufs.sourceforge.net/"
EGIT_REPO_URI="git://aufs.git.sourceforge.net/gitroot/aufs/aufs3-standalone.git"
EGIT_NONBARE=yes

RDEPEND="!sys-fs/aufs3 !sys-fs/aufs2 =sys-fs/${P/standalone/utils}"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug doc fuse pax_kernel hfs inotify kernel-patch nfs ramfs"

S="${WORKDIR}"/${PN}

MODULE_NAMES="aufs(misc:${S})"

pkg_setup() {
	CONFIG_CHECK="${CONFIG_CHECK} ~EXPERIMENTAL ~PROC_FS"
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
	export EGIT_PROJECT=${PN/aufs/aufs${KV_MAJOR}}.git

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

src_prepare() {
	use pax_kernel && epatch "${FILESDIR}"/pax.patch.bz2

	sed -e 's:aufs.ko usr/include/linux/aufs_type.h:aufs.ko:g' -i Makefile || die
	sed -e 's:__user::g' -i include/linux/aufs_type.h || die
	sed -e "s:/lib/modules/${KV_FULL}/build:${KV_OUT_DIR}:g" -i Makefile || die
}

src_configure() {
	sed -e 's:AUFS_BRANCH_MAX_127.*$:AUFS_BRANCH_MAX_127 = 127:' \
		-e 's:AUFS_BRANCH_MAX_511.*$:AUFS_BRANCH_MAX_511 = 511:' \
		-e 's:AUFS_BRANCH_MAX_1023.*$:AUFS_BRANCH_MAX_1023 = 1023:' \
		-e 's:CONFIG_AUFS_BRANCH_MAX_32767.*$:CONFIG_AUFS_BRANCH_MAX_32767 = 32767:' \
		-e 's:= y:=:g' -i config.mk || die

	local config="\
		$(use debug && echo DEBUG MAGIC_SYSRQ) \
		$(use fuse && echo BR_FUSE POLL) \
		$(use hfs && echo BR_HFSPLUS) \
		$(use inotify && echo HNOTIFY HFSNOTIFY) \
		$(use nfs && echo EXPORT) \
		$(use nfs && [[ "$ABI" = "amd64" ]] && echo INO_T_64) \
		$(use ramfs && echo BR_RAMFS)"

	for option in $config PROC_MAP RDU SBILIST SP_IATTR; do
		grep -q "^CONFIG_AUFS_${option} =" config.mk ||
			die "${option} is not a valid config option"
		sed -e "/^CONFIG_AUFS_${option}/s:=:= y:g" -i config.mk || die
	done
}

src_compile() {
	export ARCH=x86
	emake CC=$(tc-getCC) CONFIG_AUFS_FS=m KDIR="${KV_DIR}"
}

src_install() {
	linux-mod_src_install
	epatch "${FILESDIR}"/aufs_type.h.patch
	install -Dpm 644 include/linux/aufs_type.h \
		"${D}"/usr/include/linux/aufs_type.h || die
	dodoc Documentation/filesystems/aufs/README
}
