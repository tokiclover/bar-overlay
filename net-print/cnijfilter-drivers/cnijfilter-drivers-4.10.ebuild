# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-drivers-4.00.ebuild,v 2.0 2014/08/06 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

MY_PN="${PN/-drivers/}"

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://www.canon-europe.com/Support/"
SRC_URI="http://gdlp01.c-wss.com/gds/8/0100005858/01/${MY_PN}-source-${PV}-1.tar.gz"

LICENSE="GPL-2"

PRINTER_USE=( "ix6700" "ix6800" "ip2800" "mx470" "mx530" "ip8700" "e560" "e400" )
PRINTER_ID=( "431" "432" "433" "434" "435" "436" "437" "438" )

IUSE="+net ${PRINTER_USE[@]}"
SLOT="${PV:0:1}"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${MY_PN}-4.00-4-ppd.patch
	"${FILESDIR}"/${MY_PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${MY_PN}-3.70-1-libexec-backend.patch
	"${FILESDIR}"/${MY_PN}-3.80-1-cups-1.6.patch
)

pkg_setup() {
	[[ ${LINGUAS} ]] && export LINGUAS="en"

	use abi_x86_32 && use amd64 && multilib_toolchain_setup "x86"

	CNIJFILTER_SRC="bscc2sts libs pstocanonij"
	PRINTER_SRC="cnijfilter cmdtocanonij"
	use usb && CNIJFILTER_SRC+=" backend"
	if use gtk; then
		CNIJFILTER_SRC+=" cngpij"
		PRINTER_SRC+=" lgmon2"
		use net && CNIJFILTER_SRC+=" cnijnpr"
	fi
	if use servicetools; then
		[[ ${ECNIJ_PVN} ]] && [[ ${PV:2:2} -le 70 ]] &&
		CNIJFILTER_SRC+=" cngpij printui" ||
		CNIJFILTER_SRC+=" cngpijmnt"
	fi
	use net && CNIJFILTER_SRC+=" backendnet"
	use usb || use net && CNIJFILTER_SRC+=" cnijbe"
}

src_prepare() {
	sed -e "s,cnijlgmon2_LDADD =,cnijlgmon2_LDADD = -L../../com/libs_bin${ABI_X86}," \
		-i lgmon2/src/Makefile.am || die

	ecnij_src_prepare
}

