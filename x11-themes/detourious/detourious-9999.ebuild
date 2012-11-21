# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/x11-themes/detourious/detourious-9999.ebuild,v 1.1 2012/11/21 19:49:15 -tclover Exp $

EAPI=2

ESVN_SUB_PROJECT="THEMES"
inherit enlightenment

DESCRIPTION="An e17 theme based/derived from detour e17 theme"
RDEPEND="x11-wm/enlightenment:0.17 !minimal? ( x11-themes/gnome-themes )"
IUSE="gtk minimal"

src_prepare() { :; }
src_configure() { :; }
src_compile() {
	emake all || die "eek!"
}

src_install() {
	insinto /usr/share/enlightenment/data/themes
	doins ./detourious.edj || die "eek!"
	if use gtk; then
		insinto /usr/share/themes
		doins -r ./gtk/detourious || die "eek!"
	fi
}
