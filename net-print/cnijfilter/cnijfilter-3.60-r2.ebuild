# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

PRINTER_MODEL=( "mg2100" "mg3100" "mg4100" "mg5300" "mg6200" "mg8200" "ip4900" "e500" )
PRINTER_ID=( "386" "387" "388" "389" "390" "391" "392" "393" )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-sg.canon-asia.com/contents/SG/EN/0100392802.html"
SRC_URI="http://gdlp01.c-wss.com/gds/8/0100003928/01/${PN}-source-${PV}-1.tar.gz"

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

