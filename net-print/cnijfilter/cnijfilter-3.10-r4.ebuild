# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-3.20-r4.ebuild,v 1.8 2012/10/26 03:10:53 -tclover Exp $

EAPI=5

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://software.canon-europe.com/software/0033571.asp"
RESTRICT="mirror"

SRC_URI="http://files.canon-europe.com/files/soft33571/software/${PN}-source-${PV}-1.tar.gz"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=("mx860" "mx320" "mx330")
ECNIJ_PRID=("347" "348" "349")
IUSE="amd64 net symlink ${ECNIJ_PRUSE[@]}"
SLOT="0"

S="${WORKDIR}"/${PN}-source-${PV}

pkg_setup() {
	if [[ "${PV:0:1}" -eq "3" ]] && [[ "${PV:2:2}" -ge "40" ]]; then
		[[ -n "$(uname -m | grep 64)" ]] && ARC=64 || ARC=32
	fi
	ecnij_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-${PV/10/20}-4-cups_ppd.patch || die
	sed -e 's/-lcnnet/-lcnnet -ldl/g' -i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	epatch "${FILESDIR}"/${PN}-${PV/10/20}-4-libpng15.patch || die
	ecnij_src_prepare
}
