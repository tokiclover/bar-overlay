# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/mkinitramfs-ll/mkinitramfs-ll-9999.ebuild v1.6 2014/07/28 08:41:42 -tclover Exp $

EAPI="5"

inherit eutils git-2

DESCRIPTION="a flexible initramfs genrating tool with full LUKS support and more"
HOMEPAGE="https://github.com/tokiclover/mkinitramfs-ll"
EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"

LICENSE="|| ( BSD-2 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS=""

IUSE_COMP="bzip2 gzip lz4 lzip lzma lzo xz"
IUSE_FS="btrfs e2fs jfs reiserfs xfs"
IUSE="aufs bash cryptsetup device-mapper dmraid fbsplash mdadm squashfs symlink
	zfs +zram zsh ${IUSE_FS/e2fs/+e2fs} ${IUSE_COMP}"

REQUIRED_USE="|| ( ${IUSE_COMP} ) || ( bash zsh )"

DEPEND="sys-apps/coreutils
	sys-apps/findutils
	sys-apps/sed
	sys-apps/grep"

RDEPEND="sys-apps/busybox[mdev]
	app-arch/cpio 
	sys-apps/kbd
	media-fonts/terminus-font[psf]
	bash? ( app-shells/bash )
	zsh? ( app-shells/zsh[unicode] )
	fbsplash? ( sys-apps/v86d media-gfx/splashutils[fbcondecor,png,truetype] )
	cryptsetup? ( sys-fs/cryptsetup )
	device-mapper? ( sys-fs/lvm2 )
	dmraid? ( sys-fs/dmraid )
	mdadm? ( sys-fs/mdadm )
	bzip2? ( app-arch/bzip2 )
	gzip? ( app-arch/gzip )
	lz4? ( app-arch/lz4 )
	lzip? ( app-arch/lzip )
	lzma? ( || ( app-arch/xz-utils app-arch/lzma ) )
	lzo? ( app-arch/lzop )
	xz? ( app-arch/xz-utils )
	aufs? ( || ( =sys-fs/aufs-utils-9999 sys-fs/aufs2 sys-fs/aufs3 ) )
	e2fs? ( sys-fs/e2fsprogs )
	btrfs? ( sys-fs/btrfs-progs )
	jfs? ( sys-fs/jfsutils )
	reiserfs? ( sys-fs/reiserfsprogs )
	squashfs? ( sys-fs/squashfs-tools[lzma?,lzo?,xz?] )
	xfs? ( sys-fs/xfsprogs )
	zfs? ( sys-fs/zfs )"

DOCS=( BUGS ChangeLog README.textile )

src_prepare() {
	# append binaries and kernel module group depending on USE
	local bin b e fs fsck kmod mod u
	for fs in ${IUSE_FS}; do
		use ${fs} && fsck+=:fsck.${fs} && mod+=:${fs}
	done
	fsck=${fsck/fsck.btrfs/btrfsck} fsck=${fsck/e2fs/ext2:fsck.ext3:fsck.ext4}
	mod=${mod/e2fs/ext2:ext3:ext4}
	use zfs && bin+=:zfs:zpool && kmod+=:zfs
	use cryptsetup && bin+=:cryptsetup && kmod+=:dm-crypt
	use device-mapper && bin+=:lvm:lvm.static && kmod+=:device-mapper
	use mdadm && bin+=:mdadm && kmod+=:raid
	use dmraid && bin+=:dmraid && kmod+=:dm-raid
	sed -e "s,bin]+=:.*$,bin]+=${bin}\nopts[-bin]+=${fsck}," \
		-e "s,mdep]+=:,mdep]+=${mod}\nopts\[-mdep\]+=:," \
		-e "s,kmodule]+=:,kmodule]+=${kmod}:," -i ${PN}.conf
	# set up the default compressor if xz USE flag is unset
	if ! use xz; then
		for u in ${IUSE_COMP}; do
			if use ${u}; then
				[[ "${u}" == "bzip2" ]] && e=c
				sed -e "s,xz -9 --check=crc32,${u} -${e}9," -i ${PN}.{ba,z}sh
				break
			fi
		done
	fi
}

src_install() {
	emake DESTDIR="${D}" prefix=/usr install
	if use aufs && use squashfs; then
		emake DESTDIR="${D}" prefix=/usr install_aufs_squashfs
		mv svc/README.textile README.svc.textile
		DOCS+=( README.svc.textile )
	fi
	use zram && emake DESTDIR="${D}" install_zram
	if use bash; then shell=bash
		emake DESTDIR="${D}" prefix=/usr install_bash
	fi
	if use zsh; then shell=zsh
		emake DESTDIR="${D}" prefix=/usr install_zsh
	fi
	if use symlink; then
		local bindir=/usr/sbin
		dosym ${bindir}/{${PN}.${shell},${PN/nitram/}}
		use aufs && use squashfs && dosym ${bindir}/sdr{.${shell},}
	fi
	dodoc "${DOCS[@]}"
}

pkg_postinst() {
	einfo "easiest way to build an intramfs is running:"
	einfo " \`${PN}.${shell} -a -f -y -k$(uname -r)'; and do copy usr/bin/gpg binary with"
	einfo "its usr/share/gnupg/options.skel in /usr/share/${PN} before for GnuPG support."
	if use aufs && use squashfs; then
		einfo
		einfo "If you want to squash \${PORTDIR}:var/lib/layman:var/db:var/cache/edb"
		einfo "you have to add that list to /etc/conf.d/sqfsdmount sqfsd_local and then"
		einfo "run \`sdr.${shell} -r -d\${PORTDIR}:var/lib/layman:var/db:var/cache/edb'."
		einfo "And don't forget to run \`rc-update add sqfsdmount boot' afterwards."
	fi
	if use zram; then
		einfo "to use zram init service, edit '/etc/conf.d/zram' and add the service"
		einfo "to boot run level: rc-add zram boot;"
		einfo "default config file initialize a swap and 2 devices for {/var,}/tmp."
	fi
	unset shell
}
