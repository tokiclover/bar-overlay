# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/faenza-icon-theme/faenza-icon-theme-0.7.ebuild,v 1.4 2011/01/26 16:52:26 ssuominen Exp $

inherit eutils

DESCRIPTION="collaboration between SkiesOfAzel and MonkeyMagico whose mock up was the initial inspiration behind Atolm."
HOMEPAGE="http://skiesofazel.deviantart.com/art/Atolm-191381339"
SRC_URI="${DISTDIR}/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"

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

