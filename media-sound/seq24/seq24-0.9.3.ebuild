# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/seq24/seq24-0.9.2.ebuild,v 1.7 2014/10/10 17:54:29 Exp $

EAPI=5

inherit eutils

DESCRIPTION="Seq24 is a loop based MIDI sequencer with focus on live performances."
HOMEPAGE="https://edge.launchpad.net/seq24/"
SRC_URI="https://edge.launchpad.net/seq24/trunk/${PV}/+download/${P}.tar.bz2"

IUSE="jack lash"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="media-libs/alsa-lib
	>=dev-cpp/gtkmm-2.4:2.4
	>=dev-libs/libsigc++-2.2:2
	jack? ( >=media-sound/jack-audio-connection-kit-0.90 )
	lash? ( virtual/liblash )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README RTC SEQ24 )

src_prepare()
{
  # Fix copied from openSUSE
  # https://build.opensuse.org/package/view_file/multimedia:apps/seq24/seq24.spec
  # Bug in 0.9.3 and 0.9.3 prereleases
  # class "mutex" in src/* clashes with "std::mutex" due
  # to "using namespace std;". Rename mutex to seq24_mutex.
  sed -i \
    -e 's,mutex::,seq24_mutex::,' \
    -e 's,\([ cs]\) mutex,\1 seq24_mutex,' \
    -e 's,::mutex,::seq24_mutex,' \
    src/*.h src/*.cpp
}

src_configure()
{
	local -a myeconfargs=(
		$(use_enable jack)
		$(use_enable lash)
	)
	econf "${myeconfargs[@]}"
}

src_install()
{
	emake DESTDIR="${D}" install

	dodoc "${DOCS[@]}"
	newicon src/pixmaps/seq24_32.xpm seq24.xpm
	make_desktop_entry seq24
}
