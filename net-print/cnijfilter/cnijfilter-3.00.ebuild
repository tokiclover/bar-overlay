# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.00.ebuild,v 2.0 2014/08/04 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-sg.canon-asia.com/contents/SG/EN/0100160603.html"
SRC_URI="http://gdlp01.c-wss.com/gds/6/0100001606/01/${PN}-common-${PV}-1.tar.gz"

LICENSE="GPL-2 cnijfilter"

PRINTER_USE=( "ip1900" "ip3600" "ip4600" "mp190" "mp240" "mp540" "mp630" )
PRINTER_ID=( "346" "333" "334" "342" "341" "338" "336" )

IUSE="${PRINTER_USE[@]}"
SLOT="${PV:0:1}"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-3.20-4-ppd.patch
	"${FILESDIR}"/${PN}-3.20-4-libpng15.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-${PV}-1-libexec-backend.patch
)

