# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
RESTRICT="mirror"

inherit base eutils toolchain-funcs

DESCRIPTION="JACK Recording utility"
HOMEPAGE="http://www.notam02.no/arkiv/src"
SRC_URI="http://www.notam02.no/arkiv/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gtk"

RDEPEND=">=media-libs/libsndfile-1.0.17
	>=media-sound/jack-audio-connection-kit-0.100
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	gtk? ( virtual/pkgconfig )"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.70-Makefile.patch"
)
DOCS=( README config )

src_compile()
{
	tc-export CC CXX
	emake PREFIX="${EPREFIX}/usr" jack_capture
	use gtk && emake PREFIX="${EPREFIX}/usr" jack_capture_gui2
}

src_install()
{
	dobin jack_capture
	use gtk && dobin jack_capture_gui2
	base_src_install_docs
}
