# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter/cnijfilter-3.30-r4.ebuild,v 1.8 2014/08/02 03:10:53 -tclover Exp $

EAPI=5

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-my.canon-asia.com/contents/MY/EN/0100272402.html"
SRC_URI="http://gdlp01.c-wss.com/gds/4/0100002724/01/cnijfilter-source-3.30-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=( "ip2700" "mx340" "mx350" "mx870" )
ECNIJ_PRID=( "364" "365" "366" "367" )

IUSE="net symlink ${ECNIJ_PRUSE[@]}"
SLOT="0"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-source-${PV}-1

