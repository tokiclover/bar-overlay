# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/mkinitramfs-ll/mkinitramfs-ll-0.10.4.ebuild v1.5 2012/07/17 20:05:19 -tclover Exp $

EAPI=4

inherit eutils

DESCRIPTION="a flexible initramfs genrating tool with full LUKS support and more"
HOMEPAGE="https://github.com/tokiclover/mkinitramfs-ll"
SRC_URI="${HOMEPAGE}/tarball/${PVR} -> ${P}.tar.gz"

LICENSE="|| ( BSD-2 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_COMP="bzip2 gzip lzip lzma lzo +xz"
IUSE_FS="btrfs +e2fs jfs reiserfs xfs"
IUSE="aufs bash cryptsetup device-mapper dmraid fbsplash mdadm squashfs symlink
	zfs zsh ${IUSE_FS} ${IUSE_COMP}"

REQUIRED_USE="|| ( bzip2 gzip lzip lzma lzo xz )
	|| ( bash zsh ) lzma? ( xz )"

DEPEND="sys-apps/coreutils[unicode]
	sys-apps/sed
	sys-apps/grep"

RDEPEND="sys-apps/busybox[mdev]
	app-arch/cpio 
	sys-apps/findutils
	sys-apps/kbd
	media-fonts/terminus-font[psf]
	bash? ( app-shells/bash )
	zsh? ( app-shells/zsh[unicode] )
	fbsplash? ( sys-apps/v86d 
		media-gfx/splashutils[fbcondecor,png,truetype] )
	cryptsetup? ( sys-fs/cryptsetup )
	device-mapper? ( sys-fs/lvm2 )
	dmraid? ( sys-fs/dmraid )
	mdadm? ( sys-fs/mdadm )
	bzip2? ( app-arch/bzip2 )
	gzip? ( app-arch/gzip )
	lzip? ( app-arch/lzip )
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

DOCS="KnownIssue README.textile"

src_unpack() {
	unpack "${A}"
	mv "${WORKDIR}"/{*${PN}*,${P}} || die
}

src_prepare() {
	local bin b e fs kmod mod u
	for fs in ${IUSE_FS}; do
		use ${fs} && bin+=:fsck.${fs} && mod+=:${fs}
	done
	bin=${bin/fsck.btrfs/btrfsck} && bin=${bin/e2fs/ext3:fsck.ext4}
	mod=${mod/e2fs/ext2:ext3:ext4}
	use zfs && bin+=:zfs:zpool && kmod+=:zfs
	use cryptsetup && bin+=:cryptsetup && kmod+=:dm-crypt
	use device-mapper && bin+=:lvm.static && kmod+=:device-mapper
	use mdadm && bin+=:mdadm && kmod+=:raid
	use dmraid && bin+=:dmraid && kmod+=:dm-raid
	sed -e "s,bin]+=:.*$,bin]+=${bin}," \
		-e "s,mdep]+=:,mdep]+=${mod}\nopts\[-mdep\]+=:," \
		-e "s,kmodule]+=:,kmodule]+=${kmod}:," -i ${PN}.conf
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

src_compile(){ :; }

src_install() {
	emake DESTDIR="${D}" prefix=/usr install
	if use aufs && use squashfs; then
		emake DESTDIR="${D}" install_svc
		mv svc/README.textile README.svc.textile
		DOCS+=" README.svc.textile"
	fi
	if use bash; then sh=bash
		emake DESTDIR="${D}" prefix=/usr install_bash
	fi
	if use zsh; then sh=zsh
		emake DESTDIR="${D}" prefix=/usr install_zsh
	fi
	if use symlink; then
		local bindir=/usr/sbin
		dosym ${bindir}/{${PN}.${sh},${PN/nitram/}}
		use aufs && use squashfs && dosym ${bindir}/sdr{.${sh},}
	fi
	dodoc ${DOCS}
}

pkg_postinst() {
	einfo "easiest way to build an intramfs is running in /usr/share/${PN}"
	einfo " \`${PN}.${sh} -a -f -y -k$(uname -r)', do copy [usr/bin/]gpg binary with"
	einfo "its [usr/share/gnupg/]options.skel before for GnuPG support."
	einfo "Else \`autogen.${sh} -af -y -s -l -g' will build everything in that dir"
	einfo "for kernel \$(uname -r), a [usr/root/.gnupg/]gpg.conf can be added."
	einfo "user scripts can be added to usr/etc/${PN}.d"
	if use aufs && use squashfs; then
		einfo
		einfo "If you want to squash \${PORTDIR}:var/lib/layman:var/db:var/cache/edb"
		einfo "you have to add that list to /etc/conf.d/sqfsdmount sqfsd_local and then"
		einfo "run \`sdr.${sh} -U -d \${PORTDIR}:var/lib/layman:var/db:var/cache/edb'."
		einfo "And don't forget to run \`rc-update add sqfsdmount boot' afterwards."
	fi
	unset sh
}
