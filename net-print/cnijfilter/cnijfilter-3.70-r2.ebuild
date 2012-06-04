# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-3.70-r2.ebuild,v 1.9 2012/06/04 12:28:46 -tclover Exp $

EAPI=4

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://support-asia.canon-asia.com/contents/ASIA/EN/0100411802.html"
RESTRICT="nomirror confcache"

SRC_URI="http://gdlp01.c-wss.com/gds/8/0100004118/01/${PN}-source-${PV}-1.tar.gz
"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=("ip100" "mx710" "mx890" "mx370" "mx430" "mx510" "e600")
ECNIJ_PRID=("303" "394" "395" "396" "397" "398" "399")
IUSE="net ${ECNIJ_PRUSE[@]}"
SLOT=${PV}

S="${WORKDIR}"/${PN}-source-${PV}-1

src_prepare() {
	sed -e 's/-lcnnet/-lcnnet -ldl/g' -i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	epatch "${FILESDIR}"/${PN}-${PV/70/20}-4-cups_ppd.patch || die
	epatch "${FILESDIR}"/${PN}-${PV/70/20}-4-libpng15.patch || die
	ecnij_src_prepare
}

src_install() {
	ecnij_src_install
	if use usb; then install -Dm644 etc/81-canonij_prn.rules \
		"${D}"/etc/udev/rules.d/81-${PN}_prn-${SLOT}.rules || die
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
