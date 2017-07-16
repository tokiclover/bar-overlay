# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: sys-kernel/mkinitramfs-ll/mkinitramfs-ll-9999.ebuild,v 1.16 2015/05/26 08:41:42 Exp $

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	VCS_ECLASS=vcs-snapshot
	SRC_URI="https://github.com/tokiclover/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	;;
esac
inherit eutils linux-info ${VCS_ECLASS}

DESCRIPTION="Lightweight, modular and powerfull initramfs genrating tool"
HOMEPAGE="https://github.com/tokiclover/mkinitramfs-ll"

LICENSE="BSD-2"
SLOT="0"

COMPRESSOR_USE=( bzip2 gzip lz4 lzo xz )
FILESYSTEM_USE=( btrfs e2fs f2fs jfs reiserfs xfs )
IUSE="aufs +bash dm-crypt device-mapper dmraid fbsplash lzma mdadm squashfs
zfs +zram zsh ${COMPRESSOR_USE[@]/xz/+xz} ${FILESYSTEM_USE[@]/e2fs/+e2fs}"

REQUIRED_USE="
	|| ( ${COMPRESSOR_USE[@]} )
	|| ( ${FILESYSTEM_USE[@]} )"

DEPEND="sys-apps/sed"
RDEPEND="app-arch/cpio
	sys-apps/findutils
	fbsplash? ( sys-apps/v86d media-gfx/splashutils[fbcondecor,png,truetype] )
	sys-apps/busybox[mdev]
	dm-crypt? ( sys-fs/cryptsetup )
	device-mapper? ( sys-fs/lvm2 )
	dmraid? ( sys-fs/dmraid )
	mdadm? ( sys-fs/mdadm )
	aufs? ( sys-fs/aufs-util )
	btrfs? ( sys-fs/btrfs-progs )
	e2fs? ( sys-fs/e2fsprogs )
	f2fs? ( sys-fs/f2fs-tools )
	jfs? ( sys-fs/jfsutils )
	reiserfs? ( sys-fs/reiserfsprogs )
	squashfs? ( sys-fs/squashfs-tools[lz4?,lzma?,lzo?,xz?] )
	xfs? ( sys-fs/xfsprogs )
	zfs? ( sys-fs/zfs )
	lzma? ( || ( app-arch/xz-utils app-arch/lzma ) )
	lzo? ( app-arch/lzop )
	xz? ( app-arch/xz-utils )
	media-fonts/terminus-font[psf]
	bash? ( app-shells/bash )
	zsh? ( app-shells/zsh[unicode] )"

for (( i=0; i<$((${#COMPRESSOR_USE[@]} - 2)); i++ )); do
	RDEPEND="${RDEPEND}
		app-arch/${COMPRESSOR_USE[$i]}"
done
unset i

pkg_setup()
{
	[[ -n "${PKG_SETUP_HAS_BEEN_RAN}" ]] && return
	CONFIG_CHECK="BLK_DEV_INITRD PROC_FS SYSFS TMPFS"
	local u U

	for u in "${COMPRESSOR_USE[@]}"; do
		U="${u^^[a-z]}"
		if use "${u}"; then
			CONFIG_CHECK+=" ~RD_${U}"
			eval : ERROR_"${U}"="no support of ${u} compressed initial ramdisk found"
		fi
	done
	for u in ${FILESYSTEM_USE[@]/e2fs}; do
		U="${u^^[a-z]}"
		if use "${u}"; then
			CONFIG_CHECK+=" ~${U}_FS"
			eval : ERROR_"${U}"="no supprt of ${u} file system found"
		fi
	done
	use e2fs && CONFIG_CHECK+=" ~EXT2_FS ~EXT3_FS ~EXT4_FS"

	linux-info_pkg_setup
	export PKG_SETUP_HAS_BEEN_RAN=1
}

src_prepare()
{
	sed -e '/COPYING.*$/d' -i Makefile
	epatch_user
}

src_install()
{
	MAKEOPTS="-j1"
	emake DESTDIR="${ED}" VERSION=${PV} PREFIX=/usr install
	if use aufs && use squashfs; then
		emake DESTDIR="${ED}" prefix=/usr install-squashdir-svc
	fi
	use zram && emake DESTDIR="${ED}" install-{zram,tmpdir}-svc

	local sh
	for sh in {ba,z}sh; do
		use ${sh} &&
		emake DESTDIR="${ED}" PREFIX=/usr install-${sh}-scripts
	done
	use bash || use zsh || emake DESTDIR="${ED}" PREFIX=/usr install-sh-scripts
}
