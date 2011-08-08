# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/faenza-icon-theme/faenza-icon-theme-0.7.ebuild,v 1.4 2011/01/26 16:52:26 ssuominen Exp $

inherit eutils

DESCRIPTION="Faenza icon theme ported to SMPlyer."
HOMEPAGE="http://reikonya.deviantart.com/"
SRC_URI="${DISTDIR}/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"

RDEPEND="!minimal? ( x11-themes/smplayer-themes )
		media-video/smplayer"

RESTRICT="binchecks strip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_install() {
	insinto /usr/share/smplayer/themes
	doins -r Faenza-SMPlayer || die "eek!"
}

