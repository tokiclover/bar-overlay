# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/enterminus/enterminus-9999.ebuild,v 1.1 2005/09/07 03:52:46 vapier Exp $

ESVN_SUB_PROJECT="THEMES"
inherit enlightenment

DESCRIPTION="An e17 theme based/derived from detour e17 theme."
RDEPEND="x11-wm/enlightenment"
IUSE="gtk"

src_unpack() {
	subversion_src_unpack
}

src_compile() {
	make all || die "eek!"
}

src_install() {
	insinto /usr/share/enlightenment/data/themes
	doins ./detourious.edj || die "eek!"
	if use gtk; then
		insinto /usr/share/themes
		doins -r ./gtk/detourious || die "eek!"
	fi
}
