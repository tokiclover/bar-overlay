# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-plugins/gmusicbrowser-art/gmusicbrowser-art-0.1.16.ebuild,v 1.1 2011/11/05 -tclover Exp $

EAPI=4

inherit git-2

DESCRIPTION="A collection of gmb-art_layouts, more info on #gmusicbrowser@DA"
HOMEPAGE="http://gmusicbrowser.deviantart.com/"
EGIT_REPO_URI="git://github.com/aboettger/gmusicbrowser-layouts.git"
EGIT_PROJECT=${PN/art/layouts}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=media-sound/gmusicbrowser-1.1.6"

src_prepare() {
	sed -e "s:gmb-art - :gmb-art_:g" \
		-e "s:faenza dark:faenza-dark:g" -i Makefile || die "eek!"
}
