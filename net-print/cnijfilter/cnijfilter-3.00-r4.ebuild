# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-3.00-r4.ebuild,v 1.8 2012/10/26 03:10:53 -tclover Exp $

EAPI=5

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://support-sg.canon-asia.com/contents/SG/EN/0100160603.html"
RESTRICT="mirror"

SRC_URI="http://gdlp01.c-wss.com/gds/6/0100001606/01/${PN}-common-${PV}-1.tar.gz"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=("ip1900" "ip3600" "ip4600" "mp190" "mp240" "mp540" "mp630")
ECNIJ_PRID=("346" "333" "334" "342" "341" "338" "336")
IUSE="amd64 symlink ${ECNIJ_PRUSE[@]}"
SLOT="0"

S="${WORKDIR}"/${PN}-common-${PV}

pkg_setup() {
	if [[ "${PV:0:1}" -eq "3" ]] && [[ "${PV:2:2}" -ge "40" ]]; then
		[[ -n "$(uname -m | grep 64)" ]] && ARC=64 || ARC=32
	fi
	ecnij_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-${PV/00/20}-4-cups_ppd.patch || die
	epatch "${FILESDIR}"/${PN}-${PV/00/20}-4-libpng15.patch || die
	ecnij_src_prepare
}
