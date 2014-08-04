# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter/cnijfilter-2.60-r4.ebuild,v 1.8 2014/08/02 23:01:38 -tclover Exp $

EAPI=5

inherit ecnij rpm

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
DOWNLOAD_URL="http://support-au.canon.com.au/contents/AU/EN/0900718301.html"
SRC_URI="http://gdlp01.c-wss.com/gds/3/0900007183/02/${PN}-common-${PV}-4.src.rpm"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=( "ip2200" "ip4200" "ip6600d" "ip7700" "mp500" )
ECNIJ_PRID=( "256" "260" "265" "266" "273" )

IUSE="${ECNIJ_PRUSE[@]}"
SLOT="0"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-common-${PV}

src_prepare() {
	sed -e 's/-lxml/-lxml2/g' -i cngpijmon/src/Makefile.am -i printui/src/Makefile.am
	epatch "${FILESDIR}"/${PN}-${PV/60/70}-4-cups_ppd.patch
	epatch "${FILESDIR}"/${P%-r*}-1-png_jmpbuf-fix.patch
	epatch "${FILESDIR}"/${P%-r*}-1-pstocanonij.patch
	epatch "${FILESDIR}"/${P%-r*}-1-canonip4200.ppd.patch.bz2
	ecnij_src_prepare
}
