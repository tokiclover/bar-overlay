# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter/cnijfilter-3.60-r1.ebuild,v 1.8 2014/08/02 03:10:53 -tclover Exp $

EAPI=5

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-sg.canon-asia.com/contents/SG/EN/0100392802.html"
SRC_URI="http://gdlp01.c-wss.com/gds/8/0100003928/01/${PN}-source-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=( "mg2100" "mg3100" "mg4100" "mg5300" "mg6200" "mg8200" "ip4900" "e500" )
ECNIJ_PRID=( "386" "387" "388" "389" "390" "391" "392" "393" )

IUSE="net symlink ${ECNIJ_PRUSE[@]}"
SLOT="0"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-source-${PV}-1

src_prepare() {
	sed -e 's/-lcnnet/-lcnnet -ldl/g' -i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	epatch "${FILESDIR}"/${PN}-${PV/60/20}-4-cups_ppd.patch
	epatch "${FILESDIR}"/${PN}-${PV/60/20}-4-libpng15.patch
	ecnij_src_prepare
}
