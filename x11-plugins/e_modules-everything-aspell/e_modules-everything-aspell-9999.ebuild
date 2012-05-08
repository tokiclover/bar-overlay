# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:
# bar-overlay/x11-plugins/e_modules-everything-aspell-9999.ebuild,v 1.1 2012/03/18 -tclover Exp $

EAPI="2"
ESVN_SUB_PROJECT="E-MODULES-EXTRA"
ESVN_URI_APPEND="${PN#e_modules-}"

inherit enlightenment

DESCRIPTION="everything-aspell module for enlightenment - E17"

IUSE="static-libs"

RDEPEND=">=x11-wm/enlightenment-9999[e_modules_everything]"
DEPEND="${RDEPEND}"
