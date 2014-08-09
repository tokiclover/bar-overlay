# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.30.ebuild,v 2.0 2014/08/04 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-my.canon-asia.com/contents/MY/EN/0100272402.html"
SRC_URI="http://gdlp01.c-wss.com/gds/4/0100002724/01/${PN}-source-${PV}-1.tar.gz"

LICENSE="GPL-2 cnijfilter"

PRINTER_USE=( "ip2700" "mx340" "mx350" "mx870" )
PRINTER_ID=( "364" "365" "366" "367" )

IUSE="+net symlink ${PRINTER_USE[@]}"
SLOT="${PV:0:1}"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${PN}-3.20-4-ppd.patch
	"${FILESDIR}"/${PN}-3.20-4-libpng15.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-3.80-1-cups-1.6.patch
)

