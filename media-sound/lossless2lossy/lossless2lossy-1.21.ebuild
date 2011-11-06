# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/media-sound/lossless2lossy-1.21.ebuild,v 1.1 2011/10/27 -tclover Exp $

EAPI=3

DESCRIPTION=""
HOMEPAGE="http://lossless2lossy.sourceforge.net/"
SRC_URI="http://freefr.dl.sourceforge.net/project/lossless2lossy/lossless2lossy/lossless2lossy-v1.21/lossless2lossy-v1.21.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mac flac mp3 wavpack ogg"

DEPEND=""
RDEPEND="${DEPEND}
	mac? ( media-sound/mac )
	flac? ( media-libs/flac )
	media-sound/id3v2
	mp3? ( media-sound/lame )
	wavpack? ( media-sound/wavpack )
	ogg? ( media-libs/libogg )
"

S="${WORKDIR}"

src_install() {
	install -pd "${D}"/usr/local/bin
	install -pm 755 ${PN}-v${PV} "${D}"/usr/local/bin/${PN}.sh || die "eek!"
}
