# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter/cnijfilter-2.80-r1.ebuild,v 1.8 2014/08/02 06:45:32 -tclover Exp $

EAPI=5

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
DOWNLOAD_URL="http://support-ph.canon-asia.com/contents/PH/EN/0100119202.html"
SRC_URI="http://gdlp01.c-wss.com/gds/2/0100001192/01/${PN}-common-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=( "ip100" "ip2600" )
ECNIJ_PRID=( "303" "331" )

IUSE="${ECNIJ_PRUSE[@]}"
SLOT="0"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-common-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.20-4-cups_ppd.patch
	sed -e 's/png_p->jmpbuf/png_jmpbuf(png_p)/' -i cnijfilter/src/bjfimage.c || die
	ecnij_src_prepare
}
