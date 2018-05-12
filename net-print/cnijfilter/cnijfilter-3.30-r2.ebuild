# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

PRINTER_MODEL=( "ip2700" "mx340" "mx350" "mx870" )
PRINTER_ID=( "364" "365" "366" "367" )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-my.canon-asia.com/contents/MY/EN/0100272402.html"
SRC_URI="http://gdlp01.c-wss.com/gds/4/0100002724/01/${PN}-source-${PV}-1.tar.gz"

RESTRICT="mirror"

PATCHES=(
	"${FILESDIR}"/${PN}-3.20-4-ppd.patch
	"${FILESDIR}"/${PN}-3.20-1-libdl.patch
	"${FILESDIR}"/${PN}-3.40-4-libpng15.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-3.80-1-cups-1.6.patch
	"${FILESDIR}"/${PN}-3.70-6-headers.patch
	"${FILESDIR}"/${PN}-3.80-6-headers.patch
	"${FILESDIR}"/${PN}-3.70-6-cups-1.6.patch
)

