# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/media-sound/hydrogen/hydrogen-9999.ebuild,v 2012/11/24 01:08:24 -tclover Exp $

EAPI=4

inherit cmake-utils eutils multilib flag-o-matic toolchain-funcs subversion

DESCRIPTION="Advanced drum machine"
HOMEPAGE="http://www.hydrogen-music.org"
ESVN_REPO_URI="http://svn.assembla.com/svn/hydrogen/trunk"

LICENSE="GPL-2 ZLIB"
SLOT="0"
KEYWORDS=""
IUSE="+alsa +archive debug doc +jack jacksession ladspa lash oss portaudio
portmidi rubberband static"
REQUIRED_USE="lash? ( alsa )"

RDEPEND=">=x11-libs/qt-gui-4.3.0:4 >=x11-libs/qt-core-4.3.0:4
	archive? ( app-arch/libarchive )
	!archive? ( >=dev-libs/libtar-1.2.11-r3 )
	doc? ( app-doc/doxygen )
	>=media-libs/libsndfile-1.0.18
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( media-libs/liblrdf )
	lash? ( || ( media-sound/ladish media-sound/lash ) )
	portaudio? ( >=media-libs/portaudio-19_pre )
	portmidi? ( media-libs/portmidi )
	rubberband? ( media-libs/rubberband )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog DEVELOPERS README.txt )

src_configure() {
	local MYCMAKEARGS="\
		$(cmake-utils_use_want alsa ALSA) \
		$(cmake-utils_use_want debug DEBUG) \
		$(cmake-utils_use_want jack JACK) \
		$(cmake-utils_use_want jacksession JACKSESSION) \
		$(cmake-utils_use_no ladspa LRDF) \
		$(cmake-utils_use_want lash LASH) \
		$(cmake-utils_use_want portaudio PORTAUDIO) \
		$(cmake-utils_use_want portmidi PORTMIDI) \
		$(cmake-utils_use_want rubberband RUBBERBAND)
		$(cmake-utils_use_no static SHARED)"
	
	cmake-utils_src_configure
}
