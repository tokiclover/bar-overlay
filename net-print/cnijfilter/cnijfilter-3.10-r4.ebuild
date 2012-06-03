# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-3.20-r4.ebuild,v 1.7 2012/06/01 01:27:08 -tclover Exp $

EAPI=4

inherit ecnij

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://software.canon-europe.com/software/0033571.asp"
RESTRICT="nomirror confcache"

SRC_URI="http://files.canon-europe.com/files/soft33571/software/${PN}-source-${PV}-1.tar.gz
	scanner? ( http://gdlp01.c-wss.com/gds/4/0100001874/01/scangearmp-source-1.30-1.tar.gz )
"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

SLOT="3.10"
ECNIJ_PRUSE=("mx860" "mx320" "mx330")
ECNIJ_PRID=("347" "348" "349")
IUSE="scanner"
IUSE="amd64 net scanner ${ECNIJ_PRUSE[@]}"

if has scanner ${IUSE}; then
	if use scanner; then
		SCANSRC=../scangearmp-source-1.40-1
		ECNIJ_SRC=${SCANSRC}
	fi
	has net ${IUSE} && REQUIRED_USE="scanner? ( net )"
	DEPEND="scanner? ( >=media-gfx/gimp-2.0.0 
		media-gfx/sane-backends
		dev-libs/libusb:0 )"
fi
S="${WORKDIR}"/${PN}-source-${PV}

pkg_setup() {
	if [[ "${SLOT:0:1}" -eq "3" ]] && [[ "${SLOT:2:2}" -ge "40" ]]; then
		[[ -n "$(uname -m | grep 64)" ]] && ARC=64 || ARC=32
	fi
	ecnij_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-${PV/10/20}-4-cups_ppd.patch || die
	sed -e 's/-lcnnet/-lcnnet -ldl/g' -i cngpijmon/cnijnpr/cnijnpr/Makefile.am || die
	epatch "${FILESDIR}"/${PN}-${PV/10/20}-4-libpng15.patch || die
	if use scanner; then
		sed -i ${_scansrc}/scangearmp/backend/Makefile.am \
			-e "s:BACKEND_V_REV):BACKEND_V_REV) -L../../com/libs_bin${ARC}:" || die
		pushd ${_scansrc} && epatch "${FILESDIR}"/scangearmp-1.70-libpng15.patch && popd
	fi
	ecnij_src_prepare
}

src_install() {
	ecnij_src_install
	local bindir=/usr/bin le=/usr/libexec/cups/
	local bdir=${le}backend fdir=${le}filter gdirp pr prid 

	mv "${D}${fdir}"/pstocanonij{,${SLOT}} || die
	mv "${D}${bindir}"/cngpij{,${SLOT}} || die
	if use usb; then
		mv "${D}${bdir}"/cnijusb{,${SLOT}} || die
	fi
	if use gtk; then
		mv "${D}${bindir}"/cnijnpr{,${SLOT}} || die
	fi
	if use net; then
		mv "${D}${bdir}"/cnijnet{,${SLOT}} || die
		mv "${D}${bindir}"/cnijnetprn{,${SLOT}} || die
	fi
	if use scanner; then gdir=${ldir}/gimp/2.0/plug-ins
		dolib.so ${SCANSRC}/com/libs_bin${ARC}/* || die
		install -m644 -glp -olp ${SCANSRC}/com/ini/canon_mfp_net.ini "${D}${ldir}"/bjlib || die
		mv "${D}${bindir}"/scangearmp{,${SLOT}} || die
		dosym {${bindir}/scangearmp${SLOT},${gdir}/scangearmp${SLOT}} || die
		if use usb; then 
			install -Dm644 ${SCANSRC}/scangearmp/etc/80-canon_mfp.rules \
				"${D}"/etc/udev/rules.d/80-${PN}-${SLOT}.rules || die
		fi
	fi
}
