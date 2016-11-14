# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-2.90.ebuild,v 2.0 2015/08/04 06:45:32  Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

PRINTER_MODEL=( "ip100" "ip2600" )
PRINTER_ID=( "303" "331" )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://canon.com/"

DOWNLOAD_URL="http://support-ph.canon-asia.com/contents/PH/EN/0100119202.html"
SRC_URI="http://gdlp01.c-wss.com/gds/2/0100001192/01/${PN}-common-${PV}-1.tar.gz"

RESTRICT="mirror"

PATCHES=(
	"${FILESDIR}"/${PN}-2.70-1-png_jmpbuf-fix.patch
	"${FILESDIR}"/${PN}-2.80-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-3.20-4-ppd.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.80-6-headers.patch
	"${FILESDIR}"/${PN}-3.00-6-cups-1.6.patch
)

