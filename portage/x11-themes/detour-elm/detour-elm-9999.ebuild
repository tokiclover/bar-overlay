# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/x11-themes/detour-elm/detour-elm-9999.ebuild, v1.1 201/08/25 Exp $

EAPI=0

ESVN_SUB_PROJECT="THEMES"
inherit enlightenment

DESCRIPTION="An elm theme based/derived from detour e17 theme"

DEPEND="x11-wm/enlightenment"

src_unpack() {
	subversion_src_unpack
}

src_compile() {
	emake all || die "eek!"
}

src_install() {
	insinto /usr/share/elementary/themes
	doins detour-elm.edj || die "eek!"
}
