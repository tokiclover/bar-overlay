# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-2.60.ebuild,v 2.0 2015/08/04 23:01:38  Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

PRINTER_MODEL=( "ip2200" "ip4200" "ip6600d" "ip7700" "mp500" )
PRINTER_ID=( "256" "260" "265" "266" "273" )

inherit ecnij rpm

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://canon.com/"

DOWNLOAD_URL="http://support-au.canon.com.au/contents/AU/EN/0900718301.html"
SRC_URI="http://gdlp01.c-wss.com/gds/3/0900007183/02/${PN}-common-${PV}-4.src.rpm"

SLOT="${PV:0:1}/${PV}"

RESTRICT="mirror"
S="${WORKDIR}"/${PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-2.60-1-png_jmpbuf-fix.patch
	"${FILESDIR}"/${PN}-2.60-1-pstocanonij.patch
	"${FILESDIR}"/${PN}-2.70-4-libxml2.patch
	"${FILESDIR}"/${PN}-2.60-1-canonip4200.ppd.patch.bz2
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.80-6-headers.patch
	"${FILESDIR}"/${PN}-3.00-6-ipp.patch
)

pkg_setup() {
	ecnij_pkg_setup

	PRINTER_SRC=(${PRINTER_SRC/lgmon/stsmon})
	CNIJFILTER_SRC=(${CNIJFILTER_SRC/backend})
}
