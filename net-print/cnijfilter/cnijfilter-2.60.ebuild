# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-2.60.ebuild,v 2.0 2014/08/04 23:01:38 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

inherit ecnij rpm

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
DOWNLOAD_URL="http://support-au.canon.com.au/contents/AU/EN/0900718301.html"
SRC_URI="http://gdlp01.c-wss.com/gds/3/0900007183/02/${PN}-common-${PV}-4.src.rpm"

LICENSE="GPL-2 cnijfilter"

PRINTER_USE=( "ip2200" "ip4200" "ip6600d" "ip7700" "mp500" )
PRINTER_ID=( "256" "260" "265" "266" "273" )

IUSE="${PRINTER_USE[@]}"
SLOT="${PV:0:1}"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-2.70-1-png_jmpbuf-fix.patch
	"${FILESDIR}"/${PN}-2.70-1-pstocanonij.patch
	"${FILESDIR}"/${PN}-2.70-4-libxml2.patch
	"${FILESDIR}"/${PN}-2.70-1-canonip4200.ppd.patch.bz2
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
)

pkg_setup() {
	ecnij_pkg_setup

	PRINTER_SRC="${PRINTER_SRC/lgmon/stsmon}"
	CNIJFILTER_SRC="${CNIJFILTER_SRC/backend}"
}
