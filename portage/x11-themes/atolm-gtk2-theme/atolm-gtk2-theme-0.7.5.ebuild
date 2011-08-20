# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:
# $BAR-overlay/portage/x11-themes/faenza-icon-theme/faenza-icon-theme-0.7.5.ebuild, v1.4 2011/08/18 Exp $

inherit eutils

DESCRIPTION="A gtk2 theme based on MonckeyMagico mock up"
HOMEPAGE="http://skiesofazel.deviantart.com/art/Atolm-191381339"
SRC_URI="http://www.deviantart.com/download/191381339/atolm_by_skiesofazel-d35xysb.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"
EAPI=2

RDEPEND="!minimal? ( x11-themes/gnome-theme )"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_install() {
	unpack ./Atolm.tar.gz
	unpack ./Atolm-Squared.tar.gz
	insinto /usr/share/themes
	doins -r ./Atolm{,-Squared,.emerald} || die "eek!"
	dodoc CHANGELOG
}

