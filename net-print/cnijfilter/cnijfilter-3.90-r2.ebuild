# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

PRINTER_MODEL=( "mx720" "mx920" "mx390" "mx450" "mx520" "e660" )
PRINTER_ID=( "416" "417" "418" "419" "420" "421" )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-au.canon.com.au/contents/AU/EN/0100517102.html"
SRC_URI="http://gdlp01.c-wss.com/gds/1/0100005171/01/${PN}-source-${PV}-1.tar.gz"

IUSE="+doc"

RESTRICT="mirror"

PATCHES=(
	"${FILESDIR}"/${PN}-3.20-4-ppd.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-3.70-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-3.80-5-abi_x86_32.patch
	"${FILESDIR}"/${PN}-3.80-1-cups-1.6.patch
	"${FILESDIR}"/${PN}-${PV}-6-headers.patch
	"${FILESDIR}"/${PN}-3.80-6-cups-1.6.patch
	"${FILESDIR}"/${PN}-3.70-6-headers.patch
	"${FILESDIR}"/${PN}-3.70-6-cups-1.6.patch
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
