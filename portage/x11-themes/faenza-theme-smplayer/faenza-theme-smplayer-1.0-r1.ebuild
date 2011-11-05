# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/x11-themes/faenza-smplayer-theme-1.0-r2,v 1.1 2011/11/05 -tclover Exp $

inherit eutils

DESCRIPTION="Faenza icon theme ported to SMPlyer."
HOMEPAGE="http://reikonya.deviantart.com/"
SRC_URI="http://www.deviantart.com/download/244895655/faenza_smplayer_1_0_r1_by_reikonya-d41syp3.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal"
EAPI=2

DEPEND="app-arch/unzip"
RDEPEND="minimal? ( !x11-themes/smplayer-themes )
		media-video/smplayer"

RESTRICT="binchecks strip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_install() {
	unpack ./${PF}.tar.xz || die "eek!"
	insinto /usr/share/smplayer/themes
	doins -r Faenza{,-Darkest,-Silver}-SMPlayer || die "eek!"
}
