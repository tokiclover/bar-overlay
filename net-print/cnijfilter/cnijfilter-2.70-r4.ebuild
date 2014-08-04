# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter/cnijfilter-2.70-r4.ebuild,v 1.8 2014/08/02 23:01:33 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

inherit ecnij rpm

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
DOWNLOAD_URL="http://software.canon-europe.com/software/0027403.asp"
SRC_URI="${PN}-common-${PV}-2.src.rpm"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=( "mp160" "ip3300" "mp510" "ip4300" "mp600" "ip2500" "ip1800" "ip90" )
ECNIJ_PRID=( "291" "292" "293" "294" "295" "311" "312" "253" )

IUSE="${ECNIJ_PRUSE[@]}"
SLOT="0"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="fetch mirror"

S="${WORKDIR}"/${PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${P%-r*}-4-cups_ppd.patch
	"${FILESDIR}"/${P%-r*}-1-png_jmpbuf-fix.patch
)

src_prepare() {
	sed -e 's/-lxml/-lxml2/g' \
		-i cngpijmon/src/Makefile.am \
		-i printui/src/Makefile.am
	ecnij_src_prepare
}
