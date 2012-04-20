# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/sys-boot/mkinitramfs-ll-9999.ebuild, v1.1 2012/04/20 -tclover Exp $

EAPI=2
inherit eutils git-2

DESCRIPTION="An initramfs with full LUKS, LVM2, crypted key-file, AUFS2+SQUASHFS support"
HOMEPAGE="https://github.com/tokiclover/mkinitramfs-ll"
EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"
EGIT_PROJECT=${PN}
use zsh && EGIT_BRANCH=devel

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aufs fbsplash luks lvm raid squash symlink zsh"

DEPEND="
		sys-apps/busybox
		luks? ( sys-fs/cryptsetup[nls,static] )
		aufs? ( || ( =sys-fs/aufs-standalone-9999 sys-fs/aufs2 sys-fs/aufs3 ) )
		lvm? ( sys-fs/lvm2[static] )
		raid? ( sys-fs/mdadm )
		fbsplash? ( 
				media-gfx/splashutils[fbcondecor,png,truetype] 
				sys-apps/v86d 
		)
"

RDEPEND="zsh? ( app-shells/zsh[unicode] )
		!zsh? ( sys-apps/util-linux[nls,unicode] app-shells/bash[nls] )
"
src_compile(){ :; }
src_install() {
	emake DESTDIR="${D}" install || die "eek!"
	bzip2 ChangeLog
	bzip2 KnownIssue
	bzip2 README
	if use squash; then
		emake DESTDIR="${D}" install_sqfsd || die "eek!"
		mv sqfsd/README README-sqfsd || die "eek!"
		bzip2 README-sqfsd
	fi
	insinto /usr/local/share/${PN}/doc
	doins *.bz2 || die "eek!"
}

pkg_postinst() {
	local use zsh && shell=zsh || shell=bash
	if use symlink; then
		cd /usr/local/sbin
		ln -sf mkifs{-ll.${shell},}
		use squash && ln -sf sdr{.${shell},}
	fi
	einfo "with a static binaries of gnupg-1.4*, busybox and its applets, the easiest"
	einfo "way to build an intramfs is running in \${DISTDIR}/egit-src/${PN}"
	einfo " \`mkifs-ll.${shell} -a -k$(uname -r)' without forgeting to copy those binaries"
	einfo "before to \`\${PWD}/bin' along with options.skel to \`\${PWD}/misc/share/gnupg/'."
	einfo "Else, run \`mkifs-ll.gen.${shell} -D -s -l -g' and that script will take care of"
	einfo "everything for kernel $(uname -r), you can add gpg.conf by appending \`-C~'"
	einfo "for example. User scripts can be added to \`\${PWD}/misc' directory."
	if use squash; then
		einfo
		einfo "If you want to squash \${PORTDIR}:var/lib/layman:var/db:var/cache/edb"
		einfo "you have to add that list to /etc/conf.d/sqfsdmount sqfsd_local and then"
		einfo "run \`squash.${shell} -U -d \${PORTDIR}:var/lib/layman:var/db:var/cache/edb'."
		einfo "And don't forget to run \`rc-update add sqfsdmount boot' afterwards."
	fi
}
