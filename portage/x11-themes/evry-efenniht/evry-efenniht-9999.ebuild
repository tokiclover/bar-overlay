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

src_prepare() {
	sed -e "s:\~/.elementary:/usr/share/enlightenment/data:g" -i Makefile || die
	sed -e "s:\~/.e/e:/usr/share/enlightenment/data:g" -i Makefile || die
	sed -e "s:../../elementary/data/themes/:../evry-efenniht/:g" -i Makefile || die
}

src_compile() {
	make all || die
}

src_install() {
	emake DESTDIR="${D}" install
}
