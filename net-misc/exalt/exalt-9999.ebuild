# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-misc/exalt/exalt-9999.ebuild,v 1.1 2012/05/11 02:15:15 -tclover Exp $

ESVN_SUB_PROJECT="exalt"
inherit enlightenment

DESCRIPTION="efl based front end network manager"
IUSE="dhclient wifi"

RDEPEND="x11-wm/enlightenment
	dev-libs/e_dbus
"
DEPEND="wifi? ( net-misc/wpa_supplicant )
	dhclient? ( net-misc/dhclient )
"
