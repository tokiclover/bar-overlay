# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/x11-themes/-tolm-gtktheme-0.7.5.ebuild,v 1.1 2011/11/05 -tclover Exp $

inherit eutils

DESCRIPTION="A gtk2 theme based on MonckeyMagico mock up"
HOMEPAGE="http://skiesofazel.deviantart.com/art/Atolm-191381339"
SRC_URI="http://www.deviantart.com/download/191381339/atolm_by_skiesofazel-d35xysb.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"
EAPI=2

RDEPEND="minimal? ( !x11-themes/gnome-theme )
		x11-themes/gtk-engines-equinox
		x11-themes/gtk-engines-pixbuf
		x11-themes/gtk-engines-murrine"
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
	doins -r Atolm{,-Squared,.emerald} || die "eek!"
	dodoc CHANGELOG
}
