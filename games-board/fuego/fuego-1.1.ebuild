# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: games-board/fuego/fuego-1.1.ebuild,v 1.4 2015/05/30 23:23:04 -tclover Exp $

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=subversion
	ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}/code/trunk"
	ESVN_PROJECT=${PN}
	;;
	(*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://sourceforge/project/${PN}/${P}.tar.gz"
	;;
esac
inherit autotools-utils games ${VCS_ECLASS}

DESCRIPTION="C++ libraries for developing software for the game of Go"
HOMEPAGE="http://fuego.sourceforge.net/"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
IUSE="cache-sync doc"

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
}
