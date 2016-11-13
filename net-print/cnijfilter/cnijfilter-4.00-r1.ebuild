# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-drivers-4.00.ebuild,v 2.0 2015/08/08 03:10:53  Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

PRINTER_MODEL=( "mg7100" "mg6500" "mg6400" "mg5500" "mg3500" "mg2400" "mg2500" "p200" )
PRINTER_ID=( "423" "424" "425" "426" "427" "428" "429" "430" )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://www.canon-europe.com/Support/"
SRC_URI="http://gdlp01.c-wss.com/gds/5/0100005515/01/${PN}-source-${PV}-1.tar.gz"

IUSE="+doc +net"
SLOT="${PV:0:1}"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]
	gtk? ( virtual/libusb:1 )"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${PN}-${PV}-4-ppd.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-${PV}-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-${PV}-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-${PV}-5-abi_x86_32.patch
	"${FILESDIR}"/${PN}-3.80-1-cups-1.6.patch
	"${FILESDIR}"/${PN}-3.90-6-headers.patch
	"${FILESDIR}"/${PN}-3.80-6-ipp.patch
)

src_prepare() {
	local arc=64
	[[ x${ABI} == xx86 ]] && arc=32
	sed -e "s,cnijlgmon2_LDADD =,cnijlgmon2_LDADD = -L../../com/libs_bin${arc}," \
		-i lgmon2/src/Makefile.am || die

	ecnij_src_prepare
}

