# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-3.20-r4.ebuild,v 1.8 2012/10/26 03:10:53 -tclover Exp $

EAPI=5

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://support-asia.canon-asia.com/content/EN/0100084101.html"
RESTRICT="mirror"

SRC_URI="http://gdlp01.c-wss.com/gds/7/0100002367/01/${PN}-source-${PV}-1.tar.gz"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=("mp250" "mp270" "mp490" "mp550" "mp560" "ip4700" "mp640")
ECNIJ_PRID=("356" "357" "358" "359" "360" "361" "362")
IUSE="amd64 net symlink ${ECNIJ_PRUSE[@]}"
SLOT="0"

S="${WORKDIR}"/${PN}-source-${PV}-1

pkg_setup() {
	if [[ "${PV:0:1}" -eq "3" ]] && [[ "${PV:2:2}" -ge "40" ]]; then
		[[ -n "$(uname -m | grep 64)" ]] && ARC=64 || ARC=32
	fi
	ecnij_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P%*-r}-4-cups_ppd.patch || die
	sed -e 's/-lcnnet/-lcnnet -ldl/g' -i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	epatch "${FILESDIR}"/${P%*-r}-4-libpng15.patch || die
	ecnij_src_prepare
}
