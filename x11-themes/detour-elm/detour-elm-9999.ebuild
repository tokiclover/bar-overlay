# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/detour-elm/detour-elm-9999.ebuild,v 1.1 2012/05/08 -tclover Exp $

EAPI=2

ESVN_SUB_PROJECT="THEMES"
inherit enlightenment

DESCRIPTION="An elm theme based/derived from detour e17 theme"

DEPEND="x11-wm/enlightenment
	media-libs/edje
"

src_compile() {
	emake all || die "eek!"
}

src_install() {
	insinto /usr/share/elementary/themes
	doins detour-elm.edj || die "eek!"
}
