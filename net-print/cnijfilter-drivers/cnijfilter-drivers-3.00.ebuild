# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter/cnijfilter-3.00-r4.ebuild,v 1.8 2014/08/02 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_32 )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-sg.canon-asia.com/contents/SG/EN/0100160603.html"
SRC_URI="http://gdlp01.c-wss.com/gds/6/0100001606/01/${PN}-common-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=( "ip1900" "ip3600" "ip4600" "mp190" "mp240" "mp540" "mp630" )
ECNIJ_PRID=( "346" "333" "334" "342" "341" "338" "336" )

IUSE="symlink ${ECNIJ_PRUSE[@]}"
SLOT="0"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}-common-${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-${PV/00/20}-4-cups_ppd.patch
	"${FILESDIR}"/${PN}-${PV/00/20}-4-libpng15.patch
)

