# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-drivers-2.60.ebuild,v 2.0 2014/08/04 23:01:38 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

MY_PN="${PN/-drivers/}"

inherit ecnij rpm

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
DOWNLOAD_URL="http://support-au.canon.com.au/contents/AU/EN/0900718301.html"
SRC_URI="http://gdlp01.c-wss.com/gds/3/0900007183/02/${MY_PN}-common-${PV}-4.src.rpm"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

PRINTER_USE=( "ip2200" "ip4200" "ip6600d" "ip7700" "mp500" )
PRINTER_ID=( "256" "260" "265" "266" "273" )

IUSE="${PRINTER_USE[@]}"
SLOT="0"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${MY_PN}-${PV/60/70}-4-cups_ppd.patch
	"${FILESDIR}"/${MY_PN}-${PV}-1-png_jmpbuf-fix.patch
	"${FILESDIR}"/${MY_PN}-${PV}-1-pstocanonij.patch
	"${FILESDIR}"/${MY_PN}-${PV}-1-canonip4200.ppd.patch.bz2
)

src_prepare() {
	sed -e 's/-lxml/-lxml2/g' \
		-i cngpijmon/src/Makefile.am \
		-i printui/src/Makefile.am
	ecnij_src_prepare
}
