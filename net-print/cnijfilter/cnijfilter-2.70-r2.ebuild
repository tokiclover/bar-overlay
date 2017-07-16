# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: net-print/cnijfilter-drivers/cnijfilter-driverss-2.70.ebuild,v 2.0 2015/08/04 23:01:33  Exp $

EAPI=5

PRINTER_MODEL=( "mp160" "ip3300" "mp510" "ip4300" "mp600" "ip2500" "ip1800" "ip90" )
PRINTER_ID=( "291" "292" "293" "294" "295" "311" "312" "253" )

MULTILIB_COMPAT=( abi_x86_32 )

inherit ecnij rpm

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://canon.com/"

DOWNLOAD_URL="http://software.canon-europe.com/software/0027403.asp"
SRC_URI="http://hex1a4.net/xubuntu/HOWTO/dl/${PN}-common-${PV}-2.src.rpm"

RESTRICT="mirror"

PATCHES=(
	"${FILESDIR}"/${PN}-${PV}-4-ppd.patch
	"${FILESDIR}"/${PN}-${PV}-1-png_jmpbuf-fix.patch
	"${FILESDIR}"/${PN}-${PV}-4-libxml2.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.80-6-headers.patch
	"${FILESDIR}"/${PN}-3.00-6-cups-1.6.patch
)

pkg_setup() {
	ecnij_pkg_setup

	CNIJFILTER_SRC=(${CNIJFILTER_SRC/backend})
}
