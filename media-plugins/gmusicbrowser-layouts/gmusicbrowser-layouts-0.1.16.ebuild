# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/media-plugins/gmusicbrowser-layout/gmusicbrowser-layout-9999.ebuild,v 1.2 2012/07/04 14:52:15 -tclover Exp $

EAPI=5

inherit eutils

DESCRIPTION="A collection of nice gmusicbrowser layouts and themes"
HOMEPAGE="https://github.com/aboettger/gmusicbrowser-layouts"
SRC_URI="https://github.com/aboettger/${PN}/tarball/${PV} -> ${P}.tar.gz"
RESTRICT="nomirror confcache"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+themes"

RDEPEND=">=media-sound/gmusicbrowser-1.1.6"

src_prepare() {
	sed -e 's:gmb-art - :gmb-art_:g' \
		-e 's:faenza dark:faenza-dark:g' -i Makefile || die
	sed -e '/.*Visual.*$/d' -i layouts/gmb-art*.layout || die
}

src_install() {
	default
	use themes || rm -fr "${D}"/usr/share/gmusicbrowser/pix
}
