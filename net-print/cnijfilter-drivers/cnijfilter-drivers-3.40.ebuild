# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-drivers-3.40.ebuild,v 2.0 2014/08/04 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

MY_PN="${PN/-drivers/}"

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://software.canon-europe.com/software/0040245.asp"
SRC_URI="http://files.canon-europe.com/files/soft40245/software/${MY_PN}-source-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

PRINTER_USE=( "mp250" "mp495" "mp280" "mg5100" "mg5200" "ip4800" "mg6100" "mg8100" )
PRINTER_ID=( "356" "369" "370" "373" "374" "375" "376" "377" )

IUSE="net symlink ${PRINTER_USE[@]}"
SLOT="0"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${MY_PN}-${PV/40/20}-4-cups_ppd.patch
	"${FILESDIR}"/${MY_PN}-${PV/40/20}-4-libpng15.patch
)

src_prepare() {
	sed -e 's/-lcnnet/-lcnnet -ldl/g' \
		-i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	ecnij_src_prepare
}
