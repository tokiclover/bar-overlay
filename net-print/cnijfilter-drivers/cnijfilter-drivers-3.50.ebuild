# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter/cnijfilter-3.50.ebuild,v 1.8 2014/08/02 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://software.canon-europe.com/software/0040869.asp"
SRC_URI="http://files.canon-europe.com/files/soft40869/software/${PN}-source-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=( "mx360" "mx410" "mx420" "mx880" "ix6500" )
ECNIJ_PRID=( "380" "381" "382" "383" "384" )

IUSE="net symlink ${ECNIJ_PRUSE[@]}"
SLOT="0"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${PN}-${PV/50/20}-4-cups_ppd.patch
	"${FILESDIR}"/${PN}-${PV/50/20}-4-libpng15.patch
)

src_prepare() {
	sed -e 's/-lcnnet/-lcnnet -ldl/g' \
		-i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	ecnij_src_prepare
}
