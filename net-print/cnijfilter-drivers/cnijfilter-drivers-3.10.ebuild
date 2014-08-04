# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter/cnijfilter-3.20-r4.ebuild,v 1.8 2014/08/02 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://software.canon-europe.com/software/0033571.asp"
SRC_URI="http://files.canon-europe.com/files/soft33571/software/${PN}-source-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=( "mx860" "mx320" "mx330" )
ECNIJ_PRID=( "347" "348" "349" )

IUSE="net symlink ${ECNIJ_PRUSE[@]}"
SLOT="0"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-source-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-${PV/10/20}-4-cups_ppd.patch
	sed -e 's/-lcnnet/-lcnnet -ldl/g' -i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	epatch "${FILESDIR}"/${PN}-${PV/10/20}-4-libpng15.patch
	ecnij_src_prepare
}
