# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-plugins/gmusicbrowser-layout/gmusicbrowser-layout-0.1.16.ebuild,v 1.1 2012/07/04 12:51:03 -tclover Exp $

EAPI=4

inherit git-2

DESCRIPTION="A collection of nice gmusicbrowser layouts"
HOMEPAGE="https://github.com/aboettger/gmusicbrowser-layouts"
EGIT_REPO_URI="git://github.com/aboettger/gmusicbrowser-layouts.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=media-sound/gmusicbrowser-1.1.6"

src_prepare() {
	sed -e "s:gmb-art - :gmb_art-:g" \
		-e "s:faenza dark:faenza-dark:g" -i Makefile || die
}
