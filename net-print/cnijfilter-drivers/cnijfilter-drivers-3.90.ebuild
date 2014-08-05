# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.90.ebuild,v 1.9 2014/08/02 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

ECNIJ_SRC_BUILD="drivers"
MY_PN="${PN/-drivers/}"

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-au.canon.com.au/contents/AU/EN/0100517102.html"
SRC_URI="http://gdlp01.c-wss.com/gds/1/0100005171/01/${MY_PN}-source-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

PRINTER_USE=( "mx720" "mx920" "mx390" "mx450" "mx520" "e660" )
PRINTER_ID=( "416" "417" "418" "419" "420" "421" )

IUSE="+net ${PRINTER_USE[@]}"
SLOT="${PV}"
REQUIRED_USE="|| ( ${PRINTER_USE[@]} )"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${MY_PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${MY_PN}-3.20-4-ppd.patch
	"${FILESDIR}"/${MY_PN}-3.20-4-libpng15.patch
	"${FILESDIR}"/${MY_PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${MY_PN}-3.70-1-libexec-backend.patch
	"${FILESDIR}"/${MY_PN}-3.80-1-cups-1.6.patch
)

src_install() {
	ecnij_src_install
	if use usb; then
		insinto /etc/udev/rules.d
		doins etc/81-canonij_prn.rules
	fi
}

pkg_postinst() {
	if use usb; then
		if [ -x "$(which udevadm)" ]; then
			einfo ""
			einfo "Reloading usb rules..."
			udevadm control --reload-rules 2> /dev/null
			udevadm trigger --action=add --subsystem-match=usb 2> /dev/null
		else
			einfo ""
			einfo "Please, reload usb rules manually."
		fi
	fi	
	ecnij_pkg_postinst
}
