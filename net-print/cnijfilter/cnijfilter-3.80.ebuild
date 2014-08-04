# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter/cnijfilter-3.90.ebuild,v 1.9 2014/08/02 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

ECNIJ_SRC_BUILD="core"
MY_PN="${PN/-drivers/}"

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-au.canon.com.au/contents/AU/EN/0100517102.html"
SRC_URI="http://gdlp01.c-wss.com/gds/1/0100005171/01/${MY_PN}-source-${PV}-1.tar.gz"

LICENSE="GPL-2"

IUSE="net"
SLOT="0"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${MY_PN}-${PV/80/20}-4-libpng15.patch
)

src_prepare() {
	sed -e 's/-lcnnet/-lcnnet -ldl/g' \
		-i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	ecnij_src_prepare
}

