# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/kawoken-icon-theme/kawoken-icon-theme-1.2.ebuild,v 1.1 2012/07/04 00:22:08 -tclover Exp $

EAPI=2

inherit gnome2-utils

DESCRIPTION="kde port of--a great monochrome-ish scalable icon theme with 100³ colors and more"
HOMEPAGE="https://alecive.deviantart.com/art/"
SRC_URI="http://www.deviantart.com/download/244166779/kawoken_by_alecive-d41dcaj.zip -> ${P}.zip"

LICENSE="CC BY-NC-SA-3.0 - CC BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal"

RDEPEND="minimal? ( !kde-base/oxygen-icons )"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

MY_PN=kAwOken
S="${WORKDIR}"/${MY_PN}-${PV}

src_install() {
	unpack ./${MY_PN}.tar.gz
	mv ./${MY_PN}/Installation_and_Instructions.pdf README.pdf
	dodoc README.pdf
	dodir /usr/share/icons
	mv ./${MY_PN} "${D}"/usr/share/icons/ || die "eek!"
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
