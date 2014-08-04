# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-2.80.ebuild,v 2.0 2014/08/04 00:21:07 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

ECNIJ_SRC_BUILD="drivers"
MY_PN="${PN/-drivers/}"

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
DOWNLOAD_URL="http://support-asia.canon-asia.com/content/EN/0100084101.html"
SRC_URI="http://gdlp01.c-wss.com/gds/0100000841/${MY_PN}-common-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

PRINTER_USE=( "mp140" "mp210" "ip3500" "mp520" "ip4500" "mp610" )
PRINTER_ID=( "315" "316" "319" "328" "326" "327" )

IUSE="${PRINTER_USE[@]}"
SLOT="0"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="fetch mirror"

S="${WORKDIR}"/${MY_PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${MY_PN}-3.20-4-cups_ppd.patch
)

src_prepare() {
	sed -e 's/png_p->jmpbuf/png_jmpbuf(png_p)/' \
		-i cnijfilter/src/bjfimage.c || die
	ecnij_src_prepare
}
