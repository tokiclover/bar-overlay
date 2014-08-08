# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-themes/leopard-icon-theme/leopard-icon-theme-4.0.ebuild,v 1.1 2014/08/08 10:58:02 -tclover Exp $

EAPI=5

inherit gnome2-utils

DESCRIPTION="A very good lepard gtk port theme"
HOMEPAGE="http://badimnk.deviantart.com/"
SRC_URI="http://fc01.deviantart.net/fs71/f/2012/042/4/b/gnome_leopard_icons_by_badimnk-d4jnh34.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk -minimal"

RDEPEND="minimal? ( !x11-themes/gnome-icon-theme )
	gtk? ( x11-themes/${PN/icon/gtk} )"

DEPEND="app-arch/unzip"

RESTRICT="nomirror"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/icons
	doins -r leoicons || die
}

pkg_preinst() {
	gnome2_icon_savelist
}
pkg_postinst() {
	gnome2_icon_cache_update
}
pkg_postrm() {
	gnome2_icon_cache_update
}
