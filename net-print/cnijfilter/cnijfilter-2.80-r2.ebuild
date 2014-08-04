# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter/cnijfilter-2.80-r1.ebuild,v 1.8 2014/08/02 00:21:07 -tclover Exp $

EAPI=5

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
DOWNLOAD_URL="http://support-asia.canon-asia.com/content/EN/0100084101.html"
SRC_URI="http://gdlp01.c-wss.com/gds/0100000841/${PN}-common-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=( "mp140" "mp210" "ip3500" "mp520" "ip4500" "mp610" )
ECNIJ_PRID=( "315" "316" "319" "328" "326" "327" )

IUSE="${ECNIJ_PRUSE[@]}"
SLOT="0"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="fetch mirror"

S="${WORKDIR}"/${PN}-common-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.20-4-cups_ppd.patch
	sed -e 's/png_p->jmpbuf/png_jmpbuf(png_p)/' -i cnijfilter/src/bjfimage.c || die
	ecnij_src_prepare
}
