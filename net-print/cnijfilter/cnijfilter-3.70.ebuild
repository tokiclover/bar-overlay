# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter-drivers/cnijfilter-driverss-3.70.ebuild,v 2.0 2015/08/02 03:10:53  Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

PRINTER_MODEL=( "ip100" "mx710" "mx890" "mx370" "mx430" "mx510" "e600" )
PRINTER_ID=( "303" "394" "395" "396" "397" "398" "399" )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-asia.canon-asia.com/contents/ASIA/EN/010042.0 2015/08/04.html"
SRC_URI="http://gdlp01.c-wss.com/gds/8/0100004118/01/${PN}-source-${PV}-1.tar.gz"

IUSE="+doc +net"
SLOT="${PV:0:1}"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${PN}-3.20-4-ppd.patch
	"${FILESDIR}"/${PN}-3.20-4-libpng15.patch
	"${FILESDIR}"/${PN}-${PV}-5-abi_x86_32.patch
	"${FILESDIR}"/${PN}-${PV}-1-libexec-cups.patch
	"${FILESDIR}"/${PN}-${PV}-1-libexec-backend.patch
	"${FILESDIR}"/${PN}-3.80-1-cups-1.6.patch
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
