# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/darkness/darkness-9999.ebuild,v 1.1 2012/05/08 -tclover Exp $

EAPI=2

ESVN_SUB_PROJECT="THEMES"
inherit enlightenment

DESCRIPTION="An EFL theme based on detour"
IUSE="gtk themes"

RDEPEND="x11-wm/enlightenment
	media-libs/edje
"
src_compile() {
	 edje_cc -v -id images/ -fd . darkness.edc -o darkness.edj || die "eek!"
}

src_install() {
	insinto /usr/share/enlightenment/data/themes
	doins ./darkness.edj || die "eek!"
	if use gtk; then
		unpack ./Tenebrific.tbz2
		insinto /usr/share/themes
		doins -r ./Tenebrific  || die "eek!"
	fi
	if use themes; then
		unpack ./Ecliz_Full.bz2
		mv ./Ecliz_Full{,.tar}
		unpack ./Ecliz_Full.tar
		insinto /usr/share/icons
		doins -r ./Ecliz_Full || die "eek!"
	fi
}
