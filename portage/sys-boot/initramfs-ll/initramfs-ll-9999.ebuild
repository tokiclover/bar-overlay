# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/sys-boot/initramfs-ll/initramfs-ll-9999.ebuild, v1.1 2011/08/29 -tclover Exp $

EAPI=2

inherit git-2

DESCRIPTION="An initramfs with full LUKS, LVM2, crypted key-file, AUFS2+SQUASHFS support"
HOMEPAGE="https://github.com/tokiclover/initramfs-luks-lvm-sqfsd"
EGIT_REPO_URI="git://github.com/tokiclover/initramfs-luks-lvm-sqfsd.git"
EGIT_PROJECT=${PN}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 x86"
IUSE="aufs fbsplash extras lvm tuxonice"

DEPEND="sys-apps/v86d
		sys-fs/cryptsetup[nls,static]
		aufs? ( || ( =sys-fs/aufs-standalone-9999 sys-fs/aufs2 ) )
		lvm? ( sys-fs/lvm2[static] )
		fbsplash? ( media-gfx/splashutils[fbcondecor,png,truetype] )
		tuxonice? ( sys-apps/tuxonice-userui[fbsplash?] )
"

RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "eek!"
	bzip2 ChangeLog
	bzip2 KnownIssue
	bzip2 README
	if use extras; then
		emake DESTDIR="${D}" install_extras || die "eek!"
		emake DESTDIR="${D}" install_sqfsd || die "eek!"
		mv sqfsd/README README-sqfsd || die "eek!"
		bzip2 README-sqfsd
	fi
	insinto /usr/local/share/${PN}/doc
	doins *.bz2 || die "eek!"
}

pkg_postinst() {
	einfo
	einfo "If you have already static binaries of gnupg-1.4*, busybox and its applets"
	einfo "the easiest way to build an intramfs is running in \`/usr/share/local/${PN}'"
	einfo " \`mkifs-ll --k-version=$(uname -r) --full'. And don't forget to copy those"
	einfo "binaries before to \`./bin'  along with gpg.conf to \`./misc/.gnupg/'."
	einfo "Else, run \`mkifs-ll_gen --build-all --aufs --lvm' and that script will take"
	einfo "care of everything for kernel $(uname -r), you can add gpg.conf by appending"
	einfo "\`--conf-dir=${HOME}' argument for example."
	if use extras; then
		einfo
		einfo "If you want to squash \$PORTDIR:var/lib/layman:var/db:var/cache/edb"
		einfo "you have to add \$PORTDIR: to /etc/conf.d/sqfsdmount SQFSD_LOCAL	and"
		einfo "run \`sdr -d \$PORTDIR:var/lib/layman:var/db:var/cache/edb'."
		einfo "And don't forget to run \`rc-update add sqfsdmount boot' afterwards."
	fi
}
