# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-themes/kawoken-icon-theme/kawoken-icon-theme-1.5.ebuild,v 1.1 2014/07/15 00:22:08 -tclover Exp $

EAPI="2"

inherit gnome2-utils

MY_PN=kAwOken
DESCRIPTION="kde port of--a great monochrome-ish scalable icon theme with 100³ colors and more"
HOMEPAGE="https://alecive.deviantart.com/art/"
SRC_URI="https://dl.dropbox.com/u/8029324/${MY_PN}-${PV}.zip -> ${P}.zip"

LICENSE="CC BY-NC-SA-3.0 - CC BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal"

RDEPEND="minimal? ( !kde-base/oxygen-icons )"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

S="${WORKDIR}"/${MY_PN}-${PV}

src_install() {
	unpack ./${MY_PN}.tar.gz
	mv ./${MY_PN}/Installation_and_Instructions.pdf README.pdf
	dodoc README.pdf
	dodir /usr/share/icons
	mv ./${MY_PN} "${D}"/usr/share/icons/ || die "eek!"
}

pkg_preinst() {
	gnome2_icon_savelis
}
pkg_postinst() {
	gnome2_icon_cache_update
}
pkg_postrm() {
	gnome2_icon_cache_update
}
