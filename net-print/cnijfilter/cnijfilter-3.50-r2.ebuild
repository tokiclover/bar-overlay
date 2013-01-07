# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-3.50.ebuild,v 1.8 2012/10/26 03:10:53 -tclover Exp $

EAPI=5

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://software.canon-europe.com/software/0040869.asp"
RESTRICT="mirror"

SRC_URI="http://files.canon-europe.com/files/soft40869/software/${PN}-source-${PV}-1.tar.gz"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=("mx360" "mx410" "mx420" "mx880" "ix6500")
ECNIJ_PRID=("380" "381" "382" "383" "384")
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
	epatch "${FILESDIR}"/${PN}-${PV/50/20}-4-cups_ppd.patch || die
	sed -e 's/-lcnnet/-lcnnet -ldl/g' -i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	epatch "${FILESDIR}"/${PN}-${PV/50/20}-4-libpng15.patch || die
	ecnij_src_prepare
}
