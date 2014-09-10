# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/mkinitramfs-ll/mkinitramfs-ll-0.13.4.ebuild v1.9 2014/09/09 08:41:42 -tclover Exp $

EAPI=5

inherit eutils

DESCRIPTION="a flexible initramfs genrating tool with full LUKS support and more"
HOMEPAGE="https://github.com/tokiclover/mkinitramfs-ll"
SRC_URI="https://github.com/tokiclover/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( BSD-2 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMPRESSOR_USE=( bzip2 gzip lz4 lzip lzo xz )
FS_USE=( btrfs e2fs f2fs jfs reiserfs xfs )
IUSE="aufs +bash dm-crypt device-mapper dmraid fbsplash lzma mdadm squashfs
+symlink zfs +zram zsh ${COMPRESSOR_USE[@]/xz/+xz} ${FS_USE[@]/e2fs/+e2fs}"

REQUIRED_USE="|| ( bash zsh )
	|| ( ${COMPRESSOR_USE[@]} )
	|| ( ${FS_USE[@]} )"

DEPEND=""
RDEPEND="app-arch/cpio 
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

for (( i=0; i<((${#COMPRESSOR_USE[@]} - 2)); i++ )); do
	DEPEND="${DEPEND}
		app-arch/${COMPRESSOR_USE[$i]}"
done

DOCS=( BUGS ChangeLog README.textile )

src_prepare() {
	local bin fs fsck mod kmod

	# set up ${PN}.conf denpending on USE flags
	for fs in ${FS_USE[@]}; do
		use ${fs} && fsck+=:fsck.${fs} && kmod+=:${fs}
	done

	use e2fs && fsck="${fsck/fsck.e2fs/fsck.ext2:fsck.ext3:fsck.ext4}" \
		kmod="${kmod/e2fs/ext2:ext3:ext4}"
	use f2fs && fsck="${fsck/:fsck.f2fs}" && kmod+=:f2fs
	use zfs  && mod+=:zfs
	use zram && mod+=:zram
	use dm-crypt && bin+=:cryptsetup && mod+=:dm-crypt
	use device-mapper && bin+=:lvm && mod+=:device-mapper
	use mdadm && bin+=:mdadm && mod+=:raid
	use dmraid && bin+=:dmraid && mod+=:dm-raid

	sed -e "s,bin]+=:.*$,bin]+=${bin}\nopts[-bin]+=${fsck}," \
		-e "s,mkmod]+=,mkmod]+=${kmod}\nopts\[-mkmod\]+=," \
		-e "s,mgrp]+=,mgrp]+=${mod}\nopts[-mgrp]+=," -i ${PN}.conf

	# set up the default compressor if xz USE flag is unset
	if ! use xz; then
		for u in ${COMPRESSOR_USE[@]}; do
			if use ${u}; then
				sed -e "s,# vim,opts[-comp]=\"${u/lzo/lzop} -9\"\n#\n# vim," -i ${PN}.conf
				break
			fi
		done
	fi
}

src_install() {
	emake DESTDIR="${D}" prefix=/usr install

	if use aufs && use squashfs; then
		emake DESTDIR="${D}" prefix=/usr install_aufs_squashfs
		mv svc{/,.}README.textile && DOCS=( ${DOCS[@]} svc.README.textile )
	fi

	use zram && emake DESTDIR="${D}" install_zram

	if use bash; then
		shell=bash
		emake DESTDIR="${D}" prefix=/usr install_bash
	fi
	if use zsh; then
		shell=zsh
		emake DESTDIR="${D}" prefix=/usr install_zsh
	fi

	if use symlink; then
		local bindir=/usr/sbin
		dosym ${bindir}/{${PN}.${shell},mkinit-ll}
		use aufs && use squashfs && dosym ${bindir}/sdr{.${shell},}
	fi

	dodoc ${DOCS[@]}
}

pkg_postinst() {
	einfo "easiest way to build an intramfs is running:"
	einfo " \`${PN}.${shell} -a -f -y -k$(uname -r)'; and do copy usr/bin/gpg binary with"
	einfo "its usr/share/gnupg/options.skel in /usr/share/${PN} before for GnuPG support."
	einfo

	if use aufs && use squashfs; then
		einfo
		einfo "If you want to squash \${PORTDIR}:var/lib/layman:var/db:var/cache/edb"
		einfo "you have to add that list to /etc/conf.d/squashdir-mount and then"
		einfo "run \`sdr.${shell} -r -d\${PORTDIR}:var/lib/layman:var/db:var/cache/edb'."
		einfo "And don't forget to run \`rc-update add squashdir-mount boot' afterwards."
	fi

	if use zram; then
		einfo "to use zram init service, edit '/etc/conf.d/zram' and add the service"
		einfo "to boot run level: rc-add zram boot; /etc/init.d/zram start;"
		einfo "default config file initialize a swap and 2 devices for {/var,}/tmp."
	fi

	einfo
	einfo "And do not forget to review /etc/${PN}.conf to check the configuration!"

	unset shell
}
