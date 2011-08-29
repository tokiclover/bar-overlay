# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/sys-boot/initramfs-ll/initramfs-ll-9999.ebuild, v1.1 2011/08/29 -tclover Exp $

EAPI=2

inherit git-2

DESCRIPTION="An initramfs with full LUKS, LVM2, crypted key-file, AUFS2+SQUASHFS support"
HOMEPAGE="https://github.com/tokiclover/initramfs-luks-lvm-sqfsd"
EGIT_REPO_URI="git://github.com/tokiclover/initramfs-luks-lvm-sqfsd.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 x86"
IUSE="aufs extras lvm"

DEPEND="sys-apps/v86d
		sys-fs/cryptsetup[nls,static]
		lvm? ( sys-fs/lvm2[static] )
"

RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die "eek!"
	bzip2 ChangeLog
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
	einfo "If you have already static binaries of gnupg-1.4*, busybox [and its applets]"
	einfo "the easiest way to build an intramfs is running in \`/usr/share/local/initramfs-ll'"
	einfo " \`initramfs-ll --k-version=$(uname -r) --full'. And don't forget"
	einfo "to copy those binaries before to \`./bin'  along with gpg.conf to \`./misc/.gnupg/'."
	einfo "Else, run \`mkinitramfs-ll_gen --build-all --aufs --lvm' and that script will take"
	einfo "care of building an initramfs for kernel $(uname -r), you can add gpg.conf with"
	einfo "appending \`--conf-dir=<dir>' argument."
	if use extras; then
		einfo
		einfo "If you want to squash \$PORTDIR:var/lib/layman:var/db:var/cache/edb"
		einfo "you have to add \$PORTDIR: to /etc/conf.d/sqfsdmount SQFSD_LOCAL	and"
		einfo "run \`sqfsd-rebuild -d \$PORTDIR:var/lib/layman:var/db:var/cache/edb'"
		einfo "for more info/options run \`sqfsd-rebuild --help'."
		einfo
		einfo "And don't forget to run \`rc-update add sqfsdmount boot' afterwards."
	fi
}
