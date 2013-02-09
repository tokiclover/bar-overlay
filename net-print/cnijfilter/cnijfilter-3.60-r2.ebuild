# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-3.60-r1.ebuild,v 1.8 2012/10/26 03:10:53 -tclover Exp $

EAPI=5

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://support-sg.canon-asia.com/contents/SG/EN/0100392802.html"
RESTRICT="mirror"

SRC_URI="http://gdlp01.c-wss.com/gds/8/0100003928/01/${PN}-source-${PV}-1.tar.gz"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=("mg2100" "mg3100" "mg4100" "mg5300" "mg6200" "mg8200" "ip4900" "e500")
ECNIJ_PRID=("386" "387" "388" "389" "390" "391" "392" "393")
IUSE="net symlink ${ECNIJ_PRUSE[@]}"
SLOT="0"

S="${WORKDIR}"/${PN}-source-${PV}-1

pkg_setup() {
	if [[ "${PV:0:1}" -eq "3" ]] && [[ "${PV:2:2}" -ge "40" ]]; then
		[[ -n "$(uname -m | grep 64)" ]] && ARC=64 || ARC=32
	fi
	ecnij_pkg_setup
}

src_prepare() {
	sed -e 's/-lcnnet/-lcnnet -ldl/g' -i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	epatch "${FILESDIR}"/${PN}-${PV/60/20}-4-cups_ppd.patch || die
	epatch "${FILESDIR}"/${PN}-${PV/60/20}-4-libpng15.patch || die
	ecnij_src_prepare
}
