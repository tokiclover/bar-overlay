# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-2.70.ebuild,v 2.0 2015/08/04 23:01:33  Exp $

EAPI=5

PRINTER_MODEL=( "mp160" "ip3300" "mp510" "ip4300" "mp600" "ip2500" "ip1800" "ip90" )
PRINTER_ID=( "291" "292" "293" "294" "295" "311" "312" "253" )

MULTILIB_COMPAT=( abi_x86_32 )

inherit ecnij rpm

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
DOWNLOAD_URL="http://software.canon-europe.com/software/0027403.asp"
SRC_URI="http://hex1a4.net/xubuntu/HOWTO/dl/${PN}-common-${PV}-2.src.rpm"

SLOT="${PV:0:1}"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-${PV}-4-ppd.patch
	"${FILESDIR}"/${PN}-${PV}-1-png_jmpbuf-fix.patch
	"${FILESDIR}"/${PN}-${PV}-4-libxml2.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
)

pkg_setup() {
	ecnij_pkg_setup

	CNIJFILTER_SRC="${CNIJFILTER_SRC/backend}"
}
