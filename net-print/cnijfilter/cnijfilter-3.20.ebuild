# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.20.ebuild,v 2.0 2012/08/04 03:10:53  Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

PRINTER_MODEL=( "mp250" "mp270" "mp490" "mp550" "mp560" "ip4700" "mp640" )
PRINTER_ID=( "356" "357" "358" "359" "360" "361" "362" )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-asia.canon-asia.com/content/EN/0100084101.html"
SRC_URI="http://gdlp01.c-wss.com/gds/7/0100002367/01/${PN}-source-${PV}-1.tar.gz"

IUSE="+net"
SLOT="${PV:0:1}"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${PN}-${PV}-1-libdl.patch
	"${FILESDIR}"/${PN}-${PV}-4-ppd.patch
	"${FILESDIR}"/${PN}-${PV}-4-libpng15.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-backend.patch
)

