# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.20.ebuild,v 2.0 2015/08/04 03:10:53  Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

PRINTER_MODEL=( "mx860" "mx320" "mx330" )
PRINTER_ID=( "347" "348" "349" )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://software.canon-europe.com/software/0033571.asp"
SRC_URI="http://files.canon-europe.com/files/soft33571/software/${PN}-source-${PV}-1.tar.gz"

IUSE="+net"
SLOT="${PV:0:1}"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-source-${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-3.20-4-ppd.patch
	"${FILESDIR}"/${PN}-3.20-4-libpng15.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-${PV}-1-libdl.patch
)

