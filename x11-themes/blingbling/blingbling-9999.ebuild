# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/blingbling/blingbling-9999.ebuild,v 1.1 2012/05/08 -tclover Exp $

EAPI=2

ESVN_SUB_PROJECT="THEMES"
inherit enlightenment

DESCRIPTION="An EFL theme to make it bling: used with a golden Rolex(TM)."

DEPEND="x11-wm/enlightenment"

src_configure() { :; }
src_prepare() {
	sed	-e 's:/$$f::g' -e 's:rm -f:mkdir -p:' \
		-e 's:~/.e/e:\$(DESTDIR)/\$(prefix)/share/enlightenment/data:g' \
		-e 's:EDJE_FLAGS =.*$:prefix = /usr:' -i Makefile || die
}

src_install() {
	emake DESTDIR="${D}" install
}
