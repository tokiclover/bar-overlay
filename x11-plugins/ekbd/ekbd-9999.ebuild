# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/x11-plugins/ekbd/ekbd-9999.ebuild,v 1.1 2012/12/23 11:59:02 -tclover Exp $

EAPI=5

ESVN_SUB_PROJECT="PROTO"
inherit enlightenment

DESCRIPTION="a smart virtual keyboard and it was inspired by illume-keyboard"

IUSE="static-libs"

DEPEND=">=dev-libs/ecore-1.0
	>=dev-libs/eet-1.4.0
	>=dev-libs/eina-1.0
	>=media-libs/edje-1.0
	>=media-libs/evas-1.0
	|| ( media-libs/elementary >=x11-libs/elementary-0.5 )"

