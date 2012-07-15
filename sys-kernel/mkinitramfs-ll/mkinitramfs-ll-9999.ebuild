# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/mkinitramfs-ll/mkinitramfs-ll-9999.ebuild v1.4 2012/07/15 14:14:22 -tclover Exp $

EAPI=4

HOMEPAGE="https://github.com/tokiclover/mkinitramfs-ll"

[ "${PV}" = "9999" ] && egit=git-2 &&
	EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git" ||
	SRC_URI="${HOMEPAGE}/tarball/${PVR} -> ${P}.tar.gz"

inherit eutils ${egit}

DESCRIPTION="flexible initramfs genrating tool with full LUKS[crypted key-file],
LVM, RAID and {au+squash}fs support"
RESTRICT="nomirror confcache"
LICENSE="2-clause BSD GPL-2 GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_COMP="bzip2 gzip lzip lzma lzo +xz"
IUSE_FS="btrfs +e2fs jfs reiserfs xfs"
IUSE="aufs bash cryptsetup device-mapper dmraid fbsplash mdadm squashfs symlink
	zfs zsh ${IUSE_FS} ${IUSE_COMP}"
REQUIRED_USE="|| ( bzip2 gzip lzip lzma lzo xz )
	|| ( bash zsh ) lzma? ( xz )
"

DEPEND="sys-apps/coreutils[nls,unicode]
	sys-devel/make[nls]
	sys-apps/sed[nls]
	sys-apps/grep[nls]
"

RDEPEND="sys-apps/busybox[mdev]
	app-arch/cpio[nls] 
	sys-apps/findutils[nls]
	sys-apps/kbd[nls]
	media-fonts/terminus-font[psf]
	bash? ( sys-apps/findutils[nls] 
		app-shells/bash[nls] )
	zsh? ( app-shells/zsh[unicode] )
	fbsplash? ( sys-apps/v86d 
		media-gfx/splashutils[fbcondecor,png,truetype] )
	cryptsetup? ( sys-fs/cryptsetup[nls] )
	device-mapper? ( sys-fs/lvm2 )
	dmraid? ( sys-fs/dmraid )
	mdadm? ( sys-fs/mdadm )
	bzip2? ( || ( app-arch/bzip2 app-arch/lbzip2 app-arch/pbzip2 ) )
	gzip? ( app-arch/gzip[nls] )
	lzip? ( app-arch/lzip )
	lzo? ( app-arch/lzop )
	xz? ( app-arch/xz-utils[nls] )
	aufs? ( || ( =sys-fs/aufs-utils-9999 sys-fs/aufs2 sys-fs/aufs3 ) )
	e2fs? ( sys-fs/e2fsprogs )
	btrfs? ( sys-fs/btrfs-progs )
	jfs? ( sys-fs/jfsutils )
	reiserfs? ( sys-fs/reiserfsprogs )
	squashfs? ( sys-fs/squashfs-tools[lzma?,lzo?,xz?] )
	xfs? ( sys-fs/xfsprogs )
	zfs? ( sys-fs/zfs )
"
src_prepare() {
	local bin b conf e fs mod u
	for fs in ${IUSE_FS}; do
		use ${fs} && bin+=:fsck.${fs} && mod+=:${fs}
	done
	bin=${bin/fsck.btrfs/btrfsck} bin=${bin/e2fs/ext3:fsck.ext4}
	mod=${mod/e2fs/ext2:ext3:ext4}
	use zfs && bin+=:zfs:zpool
	use cryptsetup && bin+=:cryptsetup
	use device-mapper && bin+=:lvm.static
	use mdadm && bin+=:mdadm
	use dmraid && bin+=:dmraid
	sed -e "s,bin]+=:.*$,bin]+=:${bin}," -e "s,mdep]+=:,mdep]+=:${mod}:," -i ${PN}.conf

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
	emake DESTDIR="${D}" install
	bzip2 -9 KnownIssue
	bzip2 -9 README.textile
	if use aufs && use squashfs; then
		emake DESTDIR="${D}" install_svc
		mv svc/README.textile README.svc.textile
		bzip2 -9 README.svc.textile
	fi
	insinto /usr/local/share/${PN}/doc
	doins *.bz2 || die
	if use bash; then sh=bash
		emake DESTDIR="${D}" install_bash
	fi
	if use zsh; then sh=zsh
		emake DESTDIR="${D}" install_zsh
	fi
	if use symlink; then
		local prefix=/usr/local/sbin
		dosym ${prefix}/{${PN}.${sh},${PN/nitram/}}
		use aufs && use squashfs && dosym ${prefix}/sdr{.${sh},}
	fi
}

pkg_postinst() {
	einfo "easiest way to build an intramfs is running in /usr/local/share/${PN}"
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
