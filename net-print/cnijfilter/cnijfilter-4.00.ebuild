# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-drivers-4.00.ebuild,v 2.0 2014/08/06 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://www.canon-europe.com/Support/"
SRC_URI="http://gdlp01.c-wss.com/gds/5/0100005515/01/${PN}-source-${PV}-1.tar.gz"

LICENSE="GPL-2"

PRINTER_USE=( "mg7100" "mg6500" "mg6400" "mg5500" "mg3500" "mg2400" "mg2500" "p200" )
PRINTER_ID=( "423" "424" "425" "426" "427" "428" "429" "430" )

IUSE="+net ${PRINTER_USE[@]}"
SLOT="${PV:0:1}"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${PN}-${PV}-4-ppd.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-${PV}-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-${PV}-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.80-1-cups-1.6.patch
)

src_prepare() {
	sed -e "s,cnijlgmon2_LDADD =,cnijlgmon2_LDADD = -L../../com/libs_bin${ABI_X86}," \
		-i lgmon2/src/Makefile.am || die

	ecnij_src_prepare
}

