# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/x11-plugins/e-tiling-9999.ebuild,v 1.1 2011/11/05 -tclover Exp $

ESVN_URI_APPEND="E-MODULES-EXTRA/${PN/_modules}"
inherit enlightenment

DESCRIPTION="E-Tiling is a tiling module the Enlightenment Window Manager"

DEPEND=">=x11-wm/enlightenment-9999
	>=media-libs/edje-0.5.0"
