# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.50.ebuild,v 2.0 2014/08/04 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

ECNIJ_SRC_BUILD="drivers"
MY_PN="${PN/-drivers/}"

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://software.canon-europe.com/software/0040869.asp"
SRC_URI="http://files.canon-europe.com/files/soft40869/software/${MY_PN}-source-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

PRINTER_USE=( "mx360" "mx410" "mx420" "mx880" "ix6500" )
PRINTER_ID=( "380" "381" "382" "383" "384" )

IUSE="+net symlink ${PRINTER_USE[@]}"
SLOT="${PV}"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${MY_PN}-3.20-4-ppd.patch
	"${FILESDIR}"/${MY_PN}-3.20-4-libpng15.patch
	"${FILESDIR}"/${MY_PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${MY_PN}-3.70-1-libexec-backend.patch
	"${FILESDIR}"/${MY_PN}-3.80-1-cups-1.6.patch
)

