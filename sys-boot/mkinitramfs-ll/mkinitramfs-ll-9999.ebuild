# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-boot/mkinitramfs-ll/mkinitramfs-ll-9999.ebuild v1.2 2012/05/09 13:35:29 -tclover Exp $

EAPI=2
inherit eutils git-2

DESCRIPTION="An initramfs with full LUKS, LVM2, crypted key-file, AUFS2+SQUASHFS support"
HOMEPAGE="https://github.com/tokiclover/mkinitramfs-ll"
EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"
EGIT_PROJECT=${PN}

LICENSE="2-clause BSD GPL-2 GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aufs bash fbsplash luks lvm raid squash symlink zsh"

DEPEND=" aufs? ( || ( =sys-fs/aufs-standalone-9999 sys-fs/aufs2 sys-fs/aufs3 ) )
		fbsplash? ( 
				media-gfx/splashutils[fbcondecor,png,truetype] 
				sys-apps/v86d 
		)
		luks? ( sys-fs/cryptsetup[nls,static] )
		lvm? ( sys-fs/lvm2[static] )
		raid? ( sys-fs/mdadm )
		sys-apps/busybox
"

RDEPEND="zsh? ( app-shells/zsh[unicode] )
		bash? ( sys-apps/util-linux[nls,unicode] app-shells/bash[nls] )
"
src_compile(){ :; }
src_install() {
	cd "${WORKDIR}"/*-${PN}-*
	emake DESTDIR="${D}" install_init
	bzip2 ChangeLog
	bzip2 KnownIssue
	bzip2 README.textile
	if use squash; then
		emake DESTDIR="${D}" install_svcsquash
		mv sqfsd_svc/README sqfsd_svc-README || die "eek!"
		bzip2 sqfsd_svc-README.textile
	fi
	insinto /usr/local/share/${PN}/doc
	doins *.bz2 || die "eek!"
	if use zsh; then shell=zsh
		emake DESTDIR="${D}" install_scripts_zsh
	elif use bash; then shell=bash
		emake DESTDIR="${D}" install_scripts_bash
	fi
	if use symlink; then
		cd "${D}"/usr/local/sbin
		ln -sf mkifs{-ll.${shell},}
		use squash && ln -sf sdr{.${shell},}
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
	if use squash; then
		einfo
		einfo "If you want to squash \${PORTDIR}:var/lib/layman:var/db:var/cache/edb"
		einfo "you have to add that list to /etc/conf.d/sqfsdmount sqfsd_local and then"
		einfo "run \`squash.${shell} -U -d \${PORTDIR}:var/lib/layman:var/db:var/cache/edb'."
		einfo "And don't forget to run \`rc-update add sqfsdmount boot' afterwards."
	fi
}
