# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-board/fuego/fuego-1.1.ebuild,v 1.1 2014/07/15 23:23:04 -tclover Exp $

EAPI=5

inherit autotools-utils flag-o-matic games

DESCRIPTION="C++ libraries for developing software for the game of Go"
HOMEPAGE="http://fuego.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${P}.tar.gz"

LICENSE="|| (GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cache-sync doc optimization"

DEPEND="doc? ( app-doc/doxygen )
	>=dev-libs/boost-1.33.1"

RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		--prefix="${GAMES_PREFIX}"
		--libdir="$(games_get_libdir)"
		--datadir="${GAMES_DATADIR}"
		--sysconfdir="${GAMES_SYSCONFDIR}"
		--localstatedir="${GAMES_STATEDIR}"
		--enable-max-size=19
		--enable-uct-value-type=float
		$(use_enable cache-sync)
	)
	autotools-utils_src_configure
	if use optimization; then
		append-cxxflags "-ffast-math -g -pipe"
	fi
}
