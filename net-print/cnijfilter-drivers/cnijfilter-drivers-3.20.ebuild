# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.20.ebuild,v 2.0 2012/08/04 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

ECNIJ_SRC_BUILD="drivers"
MY_PN="${PN/-drivers/}"

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-asia.canon-asia.com/content/EN/0100084101.html"
SRC_URI="http://gdlp01.c-wss.com/gds/7/0100002367/01/${MY_PN}-source-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

PRINTER_USE=( "mp250" "mp270" "mp490" "mp550" "mp560" "ip4700" "mp640" )
PRINTER_ID=( "356" "357" "358" "359" "360" "361" "362" )

IUSE="+net symlink ${PRINTER_USE[@]}"
SLOT="${PV}"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${MY_PN}-${PV}-4-ppd.patch
	"${FILESDIR}"/${MY_PN}-${PV}-4-libpng15.patch
	"${FILESDIR}"/${MY_PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${MY_PN}-3.70-1-libexec-backend.patch
	"${FILESDIR}"/${MY_PN}-3.10-1-libdl.patch
)

