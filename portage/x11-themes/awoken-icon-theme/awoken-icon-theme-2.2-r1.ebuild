# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/x11-themes/awoken-icon-theme/awoken-icon-theme-2.2.ebuild,v1.1 2011/09/10 Exp $

inherit gnome2-utils

DESCRIPTION="A great monochrome-ish scalable icon theme with 100³ colors and more"
HOMEPAGE="http://alecive.deviantart.com/art/"
SRC_URI="http://www.deviantart.com/download/163570862/awoken_by_alecive-d2pdw32.zip -> ${P}.zip"

LICENSE="CC BY-NC-SA-3.0 - CC BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"
EAPI=2

RDEPEND="minimal? ( !x11-themes/gnome-icon-theme )"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

MY_PN=AwOken
S=${WORKDIR}/${MY_PN}-${PV/-r[0-9]*}

src_unpack() {
	unpack ${A}
}

src_install() {
	unpack ./${MY_PN}.tar.gz
	unpack ./${MY_PN}Dark.tar.gz
	mv ${MY_PN}/Installation_and_Instructions.pdf README.pdf
	dodoc README.pdf
	insinto /usr/local/bin
	doins ${MY_PN}/awoken-icon-theme-customization{,-clear} \
		${MY_PN}Dark/awoken-icon-theme-customization-dark || die "eek!"
	doins /usr/share/icons
	insinto -r ${MY_PN}{,Dark} || die "eek!"
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() {
	gnome2_icon_cache_update
	einfo
	einfo "one should run the scripts to delete previous profile to create a"
	einfo "new one or colorize the icon set"
	einfo
}
pkg_postrm() { gnome2_icon_cache_update; }
