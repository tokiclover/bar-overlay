# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.50.ebuild,v 2.0 2015/08/08 03:10:53  Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

PRINTER_MODEL=( "mx360" "mx410" "mx420" "mx880" "ix6500" )
PRINTER_ID=( "380" "381" "382" "383" "384" )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://software.canon-europe.com/software/0040869.asp"
SRC_URI="http://files.canon-europe.com/files/soft40869/software/${PN}-source-${PV}-1.tar.gz"

IUSE="+doc"

RESTRICT="mirror"

PATCHES=(
	"${FILESDIR}"/${PN}-3.20-4-ppd.patch
	"${FILESDIR}"/${PN}-3.20-4-libpng15.patch
	"${FILESDIR}"/${PN}-3.70-5-abi_x86_32.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-3.70-1-libdl.patch
	"${FILESDIR}"/${PN}-3.80-1-cups-1.6.patch
	"${FILESDIR}"/${PN}-3.80-6-headers.patch
	"${FILESDIR}"/${PN}-3.70-6-headers.patch
	"${FILESDIR}"/${PN}-3.70-6-cups-1.6.patch
)

