# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/x11-themes/kawoken-icon-theme/kawoken-icon-theme-0.9.ebuild,v1.1 2011/08/21 Exp $

inherit gnome2-utils

DESCRIPTION="kde port of--a great monochrome-ish scalable icon theme with 100³ colors and more"
HOMEPAGE="https://alecive.deviantart.com/art/kAwOken-244166779"
SRC_URI="http://www.deviantart.com/download/244166779/kawoken_by_alecive-d41dcaj.zip -> ${P}.zip"

LICENSE="CC BY-NC-SA-3.0 - CC BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"
EAPI=2

RDEPEND="minimal? ( !kde-base/oxygen-icons )"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

PNC=kAwOken
S=${WORKDIR}/${PNC}-${PV}

src_unpack() {
	unpack ${A}
}

src_install() {
	unpack ./${PNC}.tar.gz
	mv ./${PNC}/Installation_and_Instructions.pdf README.pdf
	dodoc README.pdf
	dodir /usr/share/icons
	mv ./${PNC} "${D}"/usr/share/icons/ || die "eek!"
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
