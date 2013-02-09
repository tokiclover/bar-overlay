# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/awoken-theme-gimp/awoken-theme-gimp-2.1.ebuild,v1.1 2012/07/04 00:21:47 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="AwOken icon theme ported to GIMP"
HOMEPAGE="http://astronommican.deviantart.com/"
SRC_URI="http://www.deviantart.com/download/203262100/awoken_dark_for_the_gimp_by_astronommican-d3d0m1g.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-gfx/gimp"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/gimp/2.0/themes
	doins -r AwOkenDark-GIMP || die "eek!"
}

