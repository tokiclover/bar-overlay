# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-2.70.ebuild,v 2.0 2014/08/04 23:01:33 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

inherit ecnij rpm

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
DOWNLOAD_URL="http://software.canon-europe.com/software/0027403.asp"
SRC_URI="${PN}-common-${PV}-2.src.rpm"

LICENSE="GPL-2 cnijfilter"

PRINTER_USE=( "mp160" "ip3300" "mp510" "ip4300" "mp600" "ip2500" "ip1800" "ip90" )
PRINTER_ID=( "291" "292" "293" "294" "295" "311" "312" "253" )

IUSE="${PRINTER_USE[@]}"
SLOT="${PV:0:1}"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="fetch mirror"

S="${WORKDIR}"/${PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-${PV}-4-ppd.patch
	"${FILESDIR}"/${PN}-${PV}-1-png_jmpbuf-fix.patch
	"${FILESDIR}"/${PN}-${PV}-4-libxml2.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
)

pkg_setup() {
	ecnij_pkg_setup

	PRINTER_SRC="${PRINTER_SRC/lgmon/stsmon}"
	CNIJFILTER_SRC="${CNIJFILTER_SRC/backend}"
}
