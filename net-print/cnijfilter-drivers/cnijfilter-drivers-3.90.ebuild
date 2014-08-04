# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-print/cnijfilter/cnijfilter-3.70-r2.ebuild,v 1.9 2014/08/02 03:10:53 -tclover Exp $

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://support-au.canon.com.au/contents/AU/EN/0100517102.html"
SRC_URI="http://gdlp01.c-wss.com/gds/1/0100005171/01/${PN}-source-${PV}-1.tar.gz"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

ECNIJ_PRUSE=( "mx720" "mx920" "mx390" "mx450" "mx520" "e660" )
ECNIJ_PRID=( "416" "417" "418" "419" "420" "421" )

IUSE="net ${ECNIJ_PRUSE[@]}"
SLOT="0"

DEPEND=">=net-print/cups-1.1.14[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}"/${PN}-source-${PV}-1

PATCHES=(
	"${FILESDIR}"/${PN}-${PV/90/20}-4-cups_ppd.patch
	"${FILESDIR}"/${PN}-${PV/90/20}-4-libpng15.patch
)

src_prepare() {
	sed -e 's/-lcnnet/-lcnnet -ldl/g' \
		-i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	ecnij_src_prepare
}

src_install() {
	ecnij_src_install
	use usb && install -Dm644 /etc/81-canonij_prn.rules \
		"${D}"/etc/udev/rules.d/81-canonij_prn.rules || die
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
