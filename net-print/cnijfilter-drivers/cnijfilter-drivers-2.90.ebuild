# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-2.90.ebuild,v 2.0 2014/08/04 06:45:32 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

ECNIJ_SRC_BUILD="drivers"
MY_PN="${PN/-drivers/}"

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
DOWNLOAD_URL="http://support-ph.canon-asia.com/contents/PH/EN/0100119202.html"
SRC_URI="http://gdlp01.c-wss.com/gds/2/0100001192/01/${MY_PN}-common-${PV}-1.tar.gz"

LICENSE="GPL-2 cnijfilter"

PRINTER_USE=( "ip100" "ip2600" )
PRINTER_ID=( "303" "331" )

IUSE="${PRINTER_USE[@]}"
SLOT="${PV}"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${MY_PN}-2.70-1-png_jmpbuf-fix.patch
	"${FILESDIR}"/${MY_PN}-2.70-1-pstocanonij.patch
	"${FILESDIR}"/${MY_PN}-2.70-4-libxml2.patch
	"${FILESDIR}"/${MY_PN}-3.20-4-ppd.patch
)

