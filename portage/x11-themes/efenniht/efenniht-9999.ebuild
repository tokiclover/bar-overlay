# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/enterminus/enterminus-9999.ebuild,v 1.1 2005/09/07 03:52:46 vapier Exp $

ESVN_SUB_PROJECT="THEMES"
inherit enlightenment

DESCRIPTION="An EFL theme based on detour"
RDEPEND="x11-wm/enlightenment"

src_unpack() {
	subversion_src_unpack
	export ESVN_REPO_URI=${ESVN_SERVER:-${E_LIVE_SERVER_DEFAULT_SVN}}/elementary && \
	ESVN_SUB_PROJECT="" && subversion_src_unpack
}

src_compile() {
	emake all || die "eek!"
}

src_install() {
	emake install-system || die "eek!"
}
