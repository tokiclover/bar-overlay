# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/x11-themes/smplayer-theme-faenza/smplayer-theme-faenza-2.ebuild,v 1.1 2012/07/04 00:22:04 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="Faenza icon theme ported to SMPlyer."
HOMEPAGE="https://opendesktop.org/content/show.php/smplayer-theme-faenza?content=156022&PHPSESSID=8611783b7ca0476c71016b3df623d1db"
SRC_URI="https://opendesktop.org/CONTENT/content-files/156022-smplayer-theme-faenza-2.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-minimal"

DEPEND="app-arch/unzip"
RDEPEND="minimal? ( !x11-themes/smplayer-themes )
		|| ( media-video/smplayer media-video/smplayer2 )"

src_install() {
	insinto /usr/share/smplayer/themes
	doins -r faenza* || die
	for dir in /usr/share/smplayer/themes/faenza{,-darkest,-silver}; do
		dosym ${EPREFIX}${dir} ${dir/player/player2}
	done
}
