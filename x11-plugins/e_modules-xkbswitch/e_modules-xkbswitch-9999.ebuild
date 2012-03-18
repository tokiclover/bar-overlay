# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/x11-plugins/xkbswitch/xkbswitch-9999.ebuild,v 1.1 2012/03/18 -tclover Exp $

ESVN_SUB_PROJECT="E-MODULES-EXTRA"
ESVN_URI_APPEND="${PN#e_modules-}"
inherit enlightenment

DESCRIPTION="XKB Switcher module for Enlightenment - E17"

IUSE="static-libs"

DEPEND=">=x11-wm/enlightenment-9999
	>=media-libs/edje-0.5.0
	>=sys-devel/gettext-0.14
	>=sys-devel/automake-1.8
"
