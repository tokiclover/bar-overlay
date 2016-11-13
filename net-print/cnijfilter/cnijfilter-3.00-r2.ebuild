# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.00.ebuild,v 2.0 2015/08/04 03:10:53  Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

PRINTER_MODEL=( "ip1900" "ip3600" "ip4600" "mp190" "mp240" "mp540" "mp630" )
PRINTER_ID=( "346" "333" "334" "342" "341" "338" "336" )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-sg.canon-asia.com/contents/SG/EN/0100160603.html"
SRC_URI="http://gdlp01.c-wss.com/gds/6/0100001606/01/${PN}-common-${PV}-1.tar.gz"

SLOT="${PV:0:1}/${PV}"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-3.20-4-ppd.patch
	"${FILESDIR}"/${PN}-3.40-4-libpng15.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-${PV}-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-3.80-6-headers.patch
	"${FILESDIR}"/${PN}-${PV}-6-ipp.patch
)

