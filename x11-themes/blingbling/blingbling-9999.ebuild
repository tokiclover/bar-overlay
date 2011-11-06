# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/x11-themes/blingbling-9999.ebuild,v 1.1 2011/11/02 -tclover Exp $

ESVN_SUB_PROJECT="THEMES"
inherit enlightenment

DESCRIPTION="An EFL theme to make it bling: used with a golden Rolex(TM)."

DEPEND="x11-wm/enlightenment"

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	sed -e 's:~/.e/e:/usr/share/enlightenment/data:g' -i Makefile || die
}

src_configure() {
	echo "no configure darn it!"
}

src_compile() {
	make all || die
}

src_install() {
	emake DESTDIR="${D}" install
}
