# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/x11-misc/emprint/emprint-9999.ebuild,v 1.1 2012/11/21 19:47:38 -tclover Exp $

EAPI=5

inherit enlightenment

DESCRIPTION="utility for taking screenshots of the entire screen"

RDEPEND="x11-libs/libX11
	>=dev-libs/ecore-1.7.1
	>=media-libs/evas-1.7.1
	>=dev-libs/eina-1.7.1
	>=media-libs/edje-1.7.1
	media-libs/imlib"
DEPEND="${RDEPEND}
	x11-proto/xproto"
