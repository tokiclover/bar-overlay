# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/enterminus/enterminus-9999.ebuild,v 1.1 2005/09/07 03:52:46 vapier Exp $

ESVN_SUB_PROJECT="E-MODULES-EXTRA"
inherit enlightenment

DESCRIPTION="X keyboard switcher module for Enlightenment 0.17"

RDEPEND="x11-wm/enlightenment"
DEPEND="x11-libs/libX11
	media-libs/edje"

