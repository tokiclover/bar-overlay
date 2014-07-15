# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-board/fuego/fuego-9999.ebuild,v 1.2 2014/07/15 23:23:04 -tclover Exp $

EAPI=3

inherit autotools-utils flag-o-matic games subversion

DESCRIPTION="C++ libraries for developing software for the game of Go"
HOMEPAGE="http://fuego.sourceforge.net/"
ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}/code/trunk"
ESVN_PROJECT=${PN}

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS=""
IUSE="cache-sync do optimization"

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
		append-cxxflags "-O3 -ffast-math -g -pipe"
	fi
}
