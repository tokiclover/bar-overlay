# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-drivers-2.90.ebuild,v 2.0 2014/08/04 06:45:32 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

MY_PN="${PN/-drivers/}"

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
DOWNLOAD_URL="http://support-ph.canon-asia.com/contents/PH/EN/0100119202.html"
SRC_URI="http://gdlp01.c-wss.com/gds/2/0100001192/01/${MY_PN}-common-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

PRINTER_USE=( "ip100" "ip2600" )
PRINTER_ID=( "303" "331" )

IUSE="${PRINTER_USE[@]}"
SLOT="0"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${MY_PN}-3.20-4-cups_ppd.patch
)

src_prepare() {
	sed -e 's/png_p->jmpbuf/png_jmpbuf(png_p)/' \
		-i cnijfilter/src/bjfimage.c || die
	ecnij_src_prepare
}
