# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/faenza-icon-theme/faenza-icon-theme-0.7.ebuild,v 1.4 2011/01/26 16:52:26 ssuominen Exp $

inherit eutils

DESCRIPTION="Faenza icon theme ported to SMPlyer."
HOMEPAGE="http://reikonya.deviantart.com/"
SRC_URI="http://www.deviantart.com/download/244895655/faenza_smplayer_9_1_p1_by_reikonya-d41syp3.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal"
EAPI=2

DEPEND="app-arch/unzip"
RDEPEND="!minimal? ( x11-themes/smplayer-themes )
		media-video/smplayer"

RESTRICT="binchecks strip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_install() {
	unpack ./${P}.tgz || die "eek!"
	insinto /usr/share/smplayer/themes
	doins -r Faenza-SMPlayer || die "eek!"
}

