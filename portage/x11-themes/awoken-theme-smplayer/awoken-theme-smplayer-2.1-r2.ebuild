# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/x11-themes/awoken-theme-smplayer/awoken-theme-smplayer-2.1_p2.ebuild,v1.1 2011/08/18 Exp $

inherit eutils

DESCRIPTION="AwOken icon theme ported to SMPlyer."
HOMEPAGE="http://reikonya.deviantart.com/"
#SRC_URI="${DISTDIR}/${P}.tgz"

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
	doins -r AwOken{,Dark}-SMPlayer || die "eek!"
}

