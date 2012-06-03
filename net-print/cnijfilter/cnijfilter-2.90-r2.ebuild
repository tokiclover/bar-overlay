# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-2.80-r1.ebuild,v 1.6 3012/05/28 06:45:32 -tclover Exp $

EAPI=4

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
DOWNLOAD_URL="http://support-ph.canon-asia.com/contents/PH/EN/0100119202.html"
RESTRICT="nomirror confcache"

SRC_URI="http://gdlp01.c-wss.com/gds/2/0100001192/01/${PN}-common-${PV}-1.tar.gz"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

SLOT="2.90"
KEYWORDS="~x86 ~amd64"
ECNIJ_PRUSE=("ip100" "ip2600")
ECNIJ_PRID=("303" "331")
IUSE="amd64 ${ECNIJ_PRUSE[@]}"
S="${WORKDIR}"/${PN}-common-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.20-4-cups_ppd.patch
	sed -e 's/png_p->jmpbuf/png_jmpbuf(png_p)/' -i cnijfilter/src/bjfimage.c || die
	ecnij_src_prepare
}

src_install() {
	ecnij_src_install
	local bindir=/usr/bin p pr prid le=/usr/libexec/cups/
	local bdir=${le}backend fdir=${le}filter

	mv "${D}${fdir}"/pstocanonij{,${SLOT}} || die
	mv "${D}${bindir}"/cngpij{,${SLOT}} || die
	if use usb; then
		mv "${D}${bdir}"/cnijusb{,${SLOT}} || die
	fi
}
