# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/enterminus/enterminus-9999.ebuild,v 1.1 2005/09/07 03:52:46 vapier Exp $

ESVN_SUB_PROJECT="THEMES"
inherit enlightenment

DESCRIPTION="An EFL theme based on detour"

DEPEND="x11-wm/enlightenment"

src_unpack() {
	subversion_src_unpack
}

src_configure() {
	sed -e "s:.elementary:enlightenment/data:g" -i Makefile || die
}

src_install() {
	emake HOME="${D}"/usr/share install || die
}
