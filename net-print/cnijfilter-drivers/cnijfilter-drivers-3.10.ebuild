# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.20.ebuild,v 2.0 2014/08/04 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

ECNIJ_SRC_BUILD="drivers"
MY_PN="${PN/-drivers/}"

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://software.canon-europe.com/software/0033571.asp"
SRC_URI="http://files.canon-europe.com/files/soft33571/software/${MY_PN}-source-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

PRINTER_USE=( "mx860" "mx320" "mx330" )
PRINTER_ID=( "347" "348" "349" )

IUSE="net symlink ${PRINTER_USE[@]}"
SLOT="0"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}-source-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-${PV/10/20}-4-cups_ppd.patch
	sed -e 's/-lcnnet/-lcnnet -ldl/g' -i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	epatch "${FILESDIR}"/${PN}-${PV/10/20}-4-libpng15.patch
	ecnij_src_prepare
}
