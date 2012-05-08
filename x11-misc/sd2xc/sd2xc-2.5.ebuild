# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-misc/sd2xc-2.5,v 1.1 2011/11/11 -tclover Exp $

EAPI=3

DESCRIPTION="This is a modified version of sd2xc.pl found online"
HOMEPAGE="http://gnomefiles.org/content/show.php?content=104659&forumpage=0&PHPSESSID=8c174d436f17abb08592334dc543fccf"
SRC_URI="${DSITDIR}/${P}.pl.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/unzip
	app-arch/gzip
	media-gfx/imagemagick[perl]
	x11-apps/xcursorgen
	dev-perl/Config-IniFiles
"
S=${WORKDIR}

src_install() {
	install -pd "${D}"/usr/local/bin
	install -pm 755 ${P}.pl "${D}"/usr/local/bin/${PN}.pl
}
