# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/net-libs/libeweather/libeweather-9999.ebuild,v 1.1 2012/12/23 11:42:11 -tclover Exp $

EAPI=5

ESVN_SUB_PROJECT="PROTO"

inherit enlightenment

DESCRIPTION="Weather information fetching and parsing framework"

LICENSE="LGPL-2.1"

IUSE="static-libs"

DEPEND=">=dev-libs/ecore-1.7.1[curl]
	>=media-libs/edje-1.7.1"
RDEPEND=${DEPEND}
