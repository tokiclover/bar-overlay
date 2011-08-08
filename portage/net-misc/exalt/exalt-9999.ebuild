# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/enterminus/enterminus-9999.ebuild,v 1.1 2005/09/07 03:52:46 vapier Exp $

ESVN_SUB_PROJECT="exalt"
inherit enlightenment

DESCRIPTION="An EFL theme based on detour"

RDEPEND="x11-wm/enlightenment
	sys-apps/dbus"
DEPEND="net-misc/wpa_supplicant
	|| ( net-misc/dhcpcd net-misc/dhcp )
    sys-apps/hal
	dev-libs/ecore
	dev-libs/eina
    dev-libs/eet
    dev-libs/e_dbus
	"
