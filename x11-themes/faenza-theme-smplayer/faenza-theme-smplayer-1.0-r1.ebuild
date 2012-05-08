# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/faenza-theme-smplayer/faenza-theme-smplayer-1.0-r1.ebuild,v 1.1 2012/05/08 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="Faenza icon theme ported to SMPlyer."
HOMEPAGE="http://reikonya.deviantart.com/"
SRC_URI="http://www.deviantart.com/download/244895655/faenza_smplayer_1_0_r1_by_reikonya-d41syp3.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal"

DEPEND="app-arch/unzip"
RDEPEND="minimal? ( !x11-themes/smplayer-themes )
		|| ( media-video/smplayer media-video/smplayer2 )"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	tar xf ${PF}.tar.xz || die "eek!"
	insinto /usr/share/smplayer/themes
	doins -r Faenza{,-Darkest,-Silver}-SMPlayer || die "eek!"
	insinto /usr/share/smplayer2/themes
	cd "${D}"/usr/share/smplayer2/themes
	for theme in Faenza{,-Darkest,-Silver}-SMPlayer
	do ln -s {../../smplayer/themes/,}$theme; done || die "eek!"
}
