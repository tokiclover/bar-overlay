# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-boot/mkinitramfs-ll/mkinitramfs-ll-0.8.2.ebuild v1.4 2012/06/18 14:13:27 -tclover Exp $

EAPI=4

inherit eutils

DESCRIPTION="initramfs building tool with full LUKS, LVM2, RAID, crypted keyfile and AUFS2+SQUASHFS support"
HOMEPAGE="https://github.com/tokiclover/mkinitramfs-ll"
SRC_URI="${HOMEPAGE}/tarball/${PVR} -> ${P}.tar.gz"
RESTRICT="nomirror confcache"
LICENSE="2-clause BSD GPL-2 GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_COMP="bzip2 gzip lzip lzma lzop +xz"
IUSE_FS="btrfs +e2fs jfs reiserfs xfs"
IUSE="aufs bash fbsplash luks lvm raid squashfs symlink zsh ${IUSE_FS} ${IUSE_COMP}"
REQUIRED_USE="|| ( bzip2 gzip lzip lzma lzop xz )
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
	luks? ( sys-fs/cryptsetup[nls,static] )
	lvm? ( sys-fs/lvm2[static] )
	raid? ( sys-fs/mdadm )
	bzip2? ( || ( app-arch/bzip2 app-arch/lbzip2 app-arch/pbzip2 ) )
	gzip? ( app-arch/gzip[nls] )
	lzip? ( app-arch/lzip )
	lzop? ( app-arch/lzopp )
	xz? ( app-arch/xz-utils[nls] )
	aufs? ( || ( =sys-fs/aufs-utils-9999 sys-fs/aufs2 sys-fs/aufs3 ) )
	e2fs? ( sys-fs/e2fsprogs )
	btrfs? ( sys-fs/btrfs-progs )
	jfs? ( sys-fs/jfsutils )
	reiserfs? ( sys-fs/reiserfsprogs )
	squashfs? ( sys-fs/squashfs-tools[lzma?,lzop?,xz?] )
	xfs? ( sys-fs/xfsprogs )
"
src_unpack() {
	unpack "${A}"
	mv "${WORKDIR}"/{*${PN}*,${P}} || die
}
src_prepare() {
	local bin b e fs u
	for fs in ${IUSE_FS}; do
		use ${fs} && bin+=:fsck.${fs}
	done
	bin=${bin/fsck.btrfs/btrfsck} bin=${bin/e2fs/ext3:fsck.ext4}
	use luks && bin+=:cryptsetup
	sed -e "s,bin]+=:.*$,bin]+=:${bin}," -i ${PN}.conf || die

	if ! use xz; then
		for u in ${IUSE_COMP}; do
			if use ${u}; then
				[[ "${u}" == "bzip2" ]] && e=c
				sed -e "s,xz -9 --check=crc32,${u} -${e}9," -i ${PN}.{ba,z}sh || die
				break
			fi
		done
	fi
}
src_compile(){ :; }
src_install() {
	emake DESTDIR="${D}" install
	bzip2 ChangeLog
	bzip2 KnownIssue
	bzip2 README.textile
	if use aufs && use squashfs; then
		emake DESTDIR="${D}" install_svc
		mv sqfsdsvc/README.textile README.sqfsdsvc.textile || die
		bzip2 README.sqfsdsvc.textile
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
	einfo "with a static binaries of gnupg-1.4*, busybox and its applets, the easiest"
	einfo "way to build an intramfs is running in \${DISTDIR}/egit-src/${PN}"
	einfo " \`${PN}.${sh} -a -k$(uname -r)' without forgeting to copy those binaries"
	einfo "before to \`\${PWD}/bin' along with options.skel to \`\${PWD}/misc/share/gnupg/'."
	einfo "Else, run \`mkinitramfs-ll-autogen.${sh} -a -s -l -g' and that script will take care of"
	einfo "everything for kernel $(uname -r), you can add gpg.conf by appending \`-C~'"
	einfo "for example. User scripts can be added to \`\${PWD}/misc' directory."
	if use aufs && use squashfs; then
		einfo
		einfo "If you want to squash \${PORTDIR}:var/lib/layman:var/db:var/cache/edb"
		einfo "you have to add that list to /etc/conf.d/sqfsdmount sqfsd_local and then"
		einfo "run \`sdr.${sh} -U -d \${PORTDIR}:var/lib/layman:var/db:var/cache/edb'."
		einfo "And don't forget to run \`rc-update add sqfsdmount boot' afterwards."
	fi
	unset sh
}
