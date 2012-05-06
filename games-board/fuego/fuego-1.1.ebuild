# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/games-board/fuego-9999.ebuild,v 1.1 2012/05/05 -tclover Exp $

EAPI=3

inherit autotools games

DESCRIPTION="C++ libraries for developing software for the game of Go"
HOMEPAGE="http://fuego.sourceforge.net/"
SRC_URI="http://heanet.dl.sourceforge.net/project/fuego/fuego/1.1/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cache-sync optimization"

DEPEND=">=sys-devel/autoconf-2.59
		>=dev-libs/boost-1.33.1
"
RDEPEND="${DEPEND}"

src_prepare() {
	WANT_AUTOCONF=2.5
	eautoreconf
}

src_configure() {
	econf \
		--enable-max-size=19
		--enable-uct-value-type=float
		$(use_enable cache-sync)
	use optimization && export CXXFLAGS="-O3 -ffast-math -g -pipe"
}
