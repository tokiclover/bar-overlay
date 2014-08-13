# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-fs/aufs-standalone/aufs-standalone-9999.ebuild v1.9 2014/08/08 23:23:44 -tclover Exp $

EAPI=5

inherit flag-o-matic linux-mod toolchain-funcs git-2

DESCRIPTION="An entirely re-designed and re-implemented Unionfs"
HOMEPAGE="http://aufs.sourceforge.net/"
EGIT_REPO_URI="git://aufs.git.sourceforge.net/gitroot/aufs/aufs3-standalone.git"
EGIT_NONBARE=yes

DEPEND="dev-util/patchutils"
RDEPEND="!sys-fs/aufs2 !sys-fs/aufs3 =sys-fs/${P/standalone/util}"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug doc fuse pax_kernel hfs inotify +kernel-patch nfs ramfs"

S="${WORKDIR}"/${PN}

KV_SUPPORT=( 4 10 17 3 )

MODULE_NAMES="aufs(misc:${S})"

pkg_setup() {
	CONFIG_CHECK="!AUFS_FS ~EXPERIMENTAL ~PROC_FS"
	use inotify && CONFIG_CHECK+=" ~FSNOTIFY"
	use nfs && CONFIG_CHECK+=" ~EXPORTFS"
	use fuse && CONFIG_CHECK+=" ~FUSE_FS"
	use hfs && CONFIG_CHECK+=" ~HFSPLUS_FS"
	use pax_kernel && CONFIG_CHECK+=" PAX"
 
	# this is needed so merging a binpkg aufs-standalone is possible
	# w/out a kernel unpacked on the system
	[ -n "$PKG_SETUP_HAS_BEEN_RAN" ] && return

	get_version

	[[ ${KV_MAJOR} != ${KV_SUPPORT[3]} ]] && die "kernel is not supported"
	kernel_is lt ${KV_MAJOR} ${KV_SUPPORT[1]} 0 &&
	[[ ${KV_SUPPORT[0]} != ${KV_MINOR} ]] && die "kernel is too old"
	kernel_is gt ${KV_MAJOR} ${KV_SUPPORT[2]} 0 && die "kernel is too new"

	local PATCHES branch patch n=/dev/null

	[[ ${KV_MINOR} -eq ${KV_SUPPORT[2]} ]] && branch=x-rcN || branch=${KV_MINOR}
	case ${branch} in
		10|12) branch=${branch}.x;;
	esac
	branch=${KV_MAJOR}.${branch}

	EGIT_BRANCH=aufs${branch}
	export EGIT_PROJECT=${PN/-/${KV_MAJOR}-}.git

	PATCHES=( "${FILESDIR}"/aufs-{base,mmap,standalone}-${branch}.patch.bz2 )

	linux-mod_pkg_setup
	if ! ( pushd ${KV_DIR}
		for patch in ${PATCHES[@]}; do
			bzip2 -dc "${patch}" | patch -p1 --dry-run --force -R >$n || {
				break; return 1
			}
		done ); then
		if use kernel-patch; then
			ewarn "Patching your kernel..."
			for patch in "${FILESDIR}"/aufs-{${PATCHES}}-${branch}.patch.bz2; do
				bzip2 -dc "${patch}" | patch --no-backup-if-mismatch --force -p1 -R -d >$n
			done
			popd
			epatch ${PATCHES[@]}
			ewarn "You need to compile your kernel with the applied patch"
			ewarn "to be able to load and use the aufs kernel module"
		else
			eerror "Apply patches to your kernel to compile and run the aufs${KV_MAJOR} module;"
			eerror "Either enable the kernel-patch USEflag to do it with this ebuild, or apply:"
			eerror "bzip2 -dc ${PATCHES[1]} | patch -p1;"
			eerror "bzip2 -dc ${PATCHES[2]} | patch -p1;"
			eerror "bzip2 -dc ${PATCHES[3]} | patch -p1;"
			die "missing kernel patch, please apply it first"
		fi
	fi
	export PKG_SETUP_HAS_BEEN_RAN=1
}

src_prepare() {
	if use pax_kernel; then
		kernel_is ge 3.11 && epatch "${FILESDIR}"/pax-3.11.patch.bz2 ||
		epatch "${FILESDIR}"/pax-3.patch.bz2
	fi

	sed -e 's:aufs.ko usr/include/linux/aufs_type.h:aufs.ko:g' \
		-e "s:/lib/modules/${KV_FULL}/build:${KV_OUT_DIR}:g" \
	 	-i Makefile || die

	epatch "${FILESDIR}"/aufs_type.h.patch
}

src_configure() {
	local config=(
		$(use debug && echo DEBUG MAGIC_SYSRQ)
		$(use fuse && echo BR_FUSE POLL)
		$(use hfs && echo BR_HFSPLUS)
		$(use inotify && echo HNOTIFY HFSNOTIFY)
		$(use nfs && echo EXPORT)
		$(use nfs && ( use amd64 || use ppc64 ) && echo INO_T_64)
		$(use ramfs && echo BR_RAMFS)
	)
	for option in ${config[@]} BRANCH_MAX_127 RDU SBILIST; do
		grep -q "^CONFIG_AUFS_${option} =" config.mk ||
			die "${option} is not a valid config option"
		sed -e "/^CONFIG_AUFS_${option}/s:=:= y:g" -i config.mk || die
	done
}

src_compile() {
	local ARCH=x86

	emake \
		CC=$(tc-getCC) \
		LD=$(tc-getLD) \
		LDFLAGS="$(raw-ldflags)" \
		ARCH=$(tc-arch-kernel) \
		CONFIG_AUFS_FS=m \
		KDIR="${KV_OUT_DIR}"
}

src_install() {
	linux-mod_src_install

	insinto /usr/include/linux
	doins include/linux/aufs_type.h

	insinto /usr/share/doc/${PF}
	use doc && doins -r Documentation/*
}
