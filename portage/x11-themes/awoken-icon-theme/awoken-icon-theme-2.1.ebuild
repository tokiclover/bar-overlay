# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/x11-themes/awoken-icon-theme/awoken-icon-theme-2.1.ebuild,v1.4 2011/08/18 Exp $

inherit gnome2-utils

DESCRIPTION="A great monochrome-ish scalable icon theme with 100³ colors and more"
HOMEPAGE="http://alecive.deviantart.com/art/"
SRC_URI="https://www.deviantart.com/download/163570862/awoken_by_alecive-d2pdw32.zip -> ${P}.zip"

LICENSE="CC BY-NC-SA-3.0 - CC BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"
EAPI=2

RDEPEND="minimal? ( !x11-themes/gnome-icon-theme )"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

PNC=AwOken
S=${WORKDIR}/${PNC}-${PV}

src_unpack() {
	unpack ${A}
}

src_install() {
	unpack ./${PNC}.tar.gz
	unpack ./${PNC}Dark.tar.gz
	mv ./${PNC}/Installation_and_Instructions.pdf README.pdf
	dodoc README.pdf
	dodir /usr/share/icons
	for dir in ${PNC}{,Dark}; do mv ./${dir} "${D}"/usr/share/icons/; done || die "eek!"
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
