# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-boot/mkinitramfs-ll/mkinitramfs-ll-9999.ebuild v1.2 2012/05/13 14:51:06 -tclover Exp $

EAPI=4
inherit eutils git-2

DESCRIPTION="An initramfs with full LUKS, LVM2, crypted key-file, AUFS2+SQUASHFS support"
HOMEPAGE="https://github.com/tokiclover/mkinitramfs-ll"
EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"
EGIT_PROJECT=${PN}

LICENSE="2-clause BSD GPL-2 GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aufs bash -bzip2 fbsplash -gzip luks -lzip -lzma -lzop lvm raid static sqfsd symlink +xz zsh"

REQUIRED_USE="|| ( bash zsh )
	|| ( bzip2 gzip lzip lzma lzop xz )
"

DEPEND="sys-apps/coreutils
	sys-devel/make
	sys-apps/sed[nls]
	sys-apps/grep[nls]
"

RDEPEND="sys-apps/busybox[mdev,static?]
	app-arch/cpio[nls] 
	sys-apps/findutils[nls]
	sqfsd? ( sys-apps/util-linux
		sys-apps/kmod
		sys-fs/squashfs-tools
		aufs? ( || ( =sys-fs/aufs-standalone-9999 sys-fs/aufs2 sys-fs/aufs3 ) )
	)
	bash? ( sys-apps/util-linux[nls,unicode] 
		app-shells/bash[nls]
	)
	zsh? ( app-shells/zsh[unicode] )
	fbsplash? ( 
			media-gfx/splashutils[fbcondecor,png,truetype] 
			sys-apps/v86d 
	)
	luks? ( sys-fs/cryptsetup[nls,static] )
	lvm? ( sys-fs/lvm2[static] )
	raid? ( sys-fs/mdadm )
	bzip2? ( || ( app-arch/bzip2 app-arch/lbzip2 app-arch/pbzip2 ) )
	gzip? ( app-arch/gzip )
	lzip? ( app-arch/lzip )
	lzma? ( app-arch/xz-utils )
	lzop? ( app-arch/lzop )
	xz? ( app-arch/xz-utils )
"
src_compile(){ :; }
src_install() {
	cd "${WORKDIR}"/*-${PN}-*
	emake DESTDIR="${D}" install
	bzip2 ChangeLog
	bzip2 KnownIssue
	bzip2 README.textile
	if use sqfsd; then
		emake DESTDIR="${D}" install_svc
		mv sqfsd_svc{/,-}README.textile || die
		bzip2 sqfsd_svc-README.textile
	fi
	insinto /usr/local/share/${PN}/doc
	doins *.bz2 || die
	if use bash; then shell=bash
		emake DESTDIR="${D}" install_bash
	fi
	if use zsh; then shell=zsh
		emake DESTDIR="${D}" install_zsh
	fi
	if use symlink; then
		cd "${D}"/usr/local/sbin
		ln -sf mkifs{-ll.${shell},}
		use sqfsd && ln -sf sdr{.${shell},}
	fi
}
pkg_postinst() {
	einfo "with a static binaries of gnupg-1.4*, busybox and its applets, the easiest"
	einfo "way to build an intramfs is running in \${DISTDIR}/egit-src/${PN}"
	einfo " \`mkifs-ll.${shell} -a -k$(uname -r)' without forgeting to copy those binaries"
	einfo "before to \`\${PWD}/bin' along with options.skel to \`\${PWD}/misc/share/gnupg/'."
	einfo "Else, run \`mkifs-ll.gen.${shell} -D -s -l -g' and that script will take care of"
	einfo "everything for kernel $(uname -r), you can add gpg.conf by appending \`-C~'"
	einfo "for example. User scripts can be added to \`\${PWD}/misc' directory."
	if use sqfsd; then
		einfo
		einfo "If you want to squash \${PORTDIR}:var/lib/layman:var/db:var/cache/edb"
		einfo "you have to add that list to /etc/conf.d/sqfsdmount sqfsd_local and then"
		einfo "run \`sdr.${shell} -U -d \${PORTDIR}:var/lib/layman:var/db:var/cache/edb'."
		einfo "And don't forget to run \`rc-update add sqfsdmount boot' afterwards."
	fi
}
