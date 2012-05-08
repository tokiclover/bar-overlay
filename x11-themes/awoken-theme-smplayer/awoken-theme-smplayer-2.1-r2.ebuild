# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/awoken-theme-smplayer/awoken-theme-smplayer-2.1-r2.ebuild,v 1.1 2012/05/08 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="AwOken icon theme ported to SMPlyer."
HOMEPAGE="http://reikonya.deviantart.com/"
SRC_URI="http://www.deviantart.com/download/205536297/awoken_1_9_for_smplayer_by_reikonya-d3edctl.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal"

RDEPEND="minimal? ( !x11-themes/smplayer-themes )
		|| ( media-video/smplayer media-video/smplayer2 )"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	for pkg in AwOken{,Dark}-SMplayer
	do unpack ./$pkg.tar.gz; done || die "eek!"
	insinto /usr/share/smplayer/themes
	doins -r AwOken{,Dark}-SMplayer || die "eek!"
	insinto /usr/share/smplayer2/themes
	cd "${D}"/usr/share/smplayer2/themes
	for theme in AwOken{,Dark}-SMplayer
	do ln -s {../../smplayer/themes/,}$theme; done || die "eek!"
}
