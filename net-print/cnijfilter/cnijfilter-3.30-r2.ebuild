# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.30.ebuild,v 2.0 2015/08/04 03:10:53  Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

PRINTER_MODEL=( "ip2700" "mx340" "mx350" "mx870" )
PRINTER_ID=( "364" "365" "366" "367" )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-my.canon-asia.com/contents/MY/EN/0100272402.html"
SRC_URI="http://gdlp01.c-wss.com/gds/4/0100002724/01/${PN}-source-${PV}-1.tar.gz"

SLOT="${PV:0:1}/${PV}"

RESTRICT="mirror"
S="${WORKDIR}"/${PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${PN}-3.20-4-ppd.patch
	"${FILESDIR}"/${PN}-3.20-1-libdl.patch
	"${FILESDIR}"/${PN}-3.40-4-libpng15.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-3.80-1-cups-1.6.patch
	"${FILESDIR}"/${PN}-3.70-6-headers.patch
	"${FILESDIR}"/${PN}-3.80-6-headers.patch
	"${FILESDIR}"/${PN}-3.70-6-ipp.patch
)

