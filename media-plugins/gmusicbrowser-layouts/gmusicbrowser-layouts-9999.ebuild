# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-plugins/gmusicbrowser-layout/gmusicbrowser-layout-9999.ebuild,v 1.2 2012/07/31 23:23:25 -tclover Exp $

EAPI=4

if [ ${PV} = 9999 ]; then egit=git-2
	EGIT_REPO_URI="git://github.com/aboettger/${PN}.git"
else SRC_URI="https://github.com/aboettger/${PN}/tarball/${PV} -> ${P}.tar.gz"; fi
inherit eutils ${egit}
unset egit

DESCRIPTION="A collection of nice gmusicbrowser layouts and themes"
HOMEPAGE="https://github.com/aboettger/gmusicbrowser-layouts"
RESTRICT="nomirror confcache"

LICENSE="GPL-2"
SLOT="0"
IUSE="+themes"

RDEPEND=">=media-sound/gmusicbrowser-1.1.6"

src_prepare() {
	sed -e "s:gmb-art - :gmb-art_:g" \
		-e "s:faenza dark:faenza_dark:g" -i Makefile || die
}

src_install() {
	default
	use themes || rm -fr "${D}"/usr/share/gmusicbrowser/pix
}
