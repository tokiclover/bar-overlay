# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/enterminus/enterminus-9999.ebuild,v 1.1 2005/09/07 03:52:46 vapier Exp $

ESVN_SUB_PROJECT="PROTO"
inherit enlightenment

DESCRIPTION="Open session with pam with the possibility to chose a WM."

DEPEND="dev-libs/ecore
	x11-libs/elementary"

RDEPEND="x11-wm/enlightenment"

src_unpack() {
	subversion_src_unpack
}
src_configure() {
	echo "nothing to do..."
}
src_compile() {
	./build.sh
}
