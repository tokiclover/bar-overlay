# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.00.ebuild,v 2.0 2014/08/04 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

ECNIJ_SRC_BUILD="drivers"
MY_PN="${PN/-drivers/}"

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-sg.canon-asia.com/contents/SG/EN/0100160603.html"
SRC_URI="http://gdlp01.c-wss.com/gds/6/0100001606/01/${MY_PN}-common-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

PRINTER_USE=( "ip1900" "ip3600" "ip4600" "mp190" "mp240" "mp540" "mp630" )
PRINTER_ID=( "346" "333" "334" "342" "341" "338" "336" )

IUSE="symlink ${PRINTER_USE[@]}"
SLOT="0"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${MY_PN}-${PV/00/20}-4-cups_ppd.patch
	"${FILESDIR}"/${MY_PN}-${PV/00/20}-4-libpng15.patch
)

