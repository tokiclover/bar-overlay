# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/enterminus/enterminus-9999.ebuild,v 1.1 2005/09/07 03:52:46 vapier Exp $

ESVN_SUB_PROJECT="eterm"
inherit enlightenment

DESCRIPTION="slightly modified eterm terminal for e17."

DEPEND="dev-libs/ecore
	media-libs/evas
	media-libs/imlib2
	net-misc/curl
	x11-libs/libast"
