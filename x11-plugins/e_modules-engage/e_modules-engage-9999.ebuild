# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-plugins/e_modules-engage/e_modules-engage-9999.ebuild,v 1.2 2014/09/16 12:02:10 -tclover Exp $

EAPI=5

EGIT_SUB_PROJECT="enlightenment/modules"
EGIT_URI_APPEND="${PN#e_modules-}"

inherit enlightenment

DESCRIPTION="a E17 shelf/launcher module for fast switching applications"

IUSE="static-libs"

DEPEND=" >=x11-wm/enlightenment-0.17.0:0.17="
RDEPEND="${DEPEND}"

