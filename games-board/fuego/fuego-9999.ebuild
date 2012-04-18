# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/games-board/fuego-9999.ebuild,v 1.1 2012/04/18 -tclover Exp $

EAPI=3

inherit autotools games subversion

DESCRIPTION="C++ libraries for developing software for the game of Go"
HOMEPAGE="http://fuego.sourceforge.net/"
ESVN_REPO_URI="https://fuego.svn.sourceforge.net/svnroot/fuego/trunk"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cache-sync optimization"

DEPEND=">=sys-devel/autoconf-2.59
	>=dev-libs/boost-1.33.1"
RDEPEND="${DEPEND}"

src_prepare() {
	WANT_AUTOCONF=2.5
	WANT_AUTOMAKE=none
	WANT_LIBTOOL=none
	eaclocal
	eautoheader
	eautoreconf

}

src_configure() {
	local myconf
	myconf+="
		--enable-max-size=19
		--enable-uct-value-type=float
		$(use_enable cache-sync)
	"
	use optimization && export CXXFLAGS="-O3 -ffast-math -g -pipe"
	./configure --prefix=/usr/games \
		--with-boost-libdir="${EPREFIX}"/usr/lib64 ${myconf} || die
}
