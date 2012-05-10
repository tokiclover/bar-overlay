# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/detourious/detourious-9999.ebuild,v 1.1 2012/05/10 12:57:38 -tclover Exp $

EAPI=2

ESVN_SUB_PROJECT="THEMES"
inherit enlightenment

DESCRIPTION="An e17 theme based/derived from detour e17 theme"
RDEPEND="x11-wm/enlightenment"
IUSE="gtk"

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
