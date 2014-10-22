# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/hydrogen/hydrogen-9999.ebuild,v 1.3 2014/10/10 02:08:24 -tclover Exp $

EAPI=5

inherit cmake-utils eutils multilib flag-o-matic toolchain-funcs git-2

DESCRIPTION="Advanced drum machine"
HOMEPAGE="http://www.hydrogen-music.org"
EGIT_REPO_URI="git://github.com/hydrogen-music/hydrogen.git"

LICENSE="GPL-2 ZLIB"
SLOT="0"
KEYWORDS=""
IUSE="+alsa +archive debug doc +jack jack-session ladspa lash oss portaudio
-pulseaudio portmidi rubberband static"
REQUIRED_USE="lash? ( alsa )"

RDEPEND=">=dev-qt/qtgui-4.4.0:4 >=dev-qt/qtcore-4.4.0:4
	archive? ( app-arch/libarchive )
	!archive? ( >=dev-libs/libtar-1.2.11-r3 )
	doc? ( app-doc/doxygen )
	>=media-libs/libsndfile-1.0.18
	alsa? ( media-libs/alsa-lib )
	jack? ( >=media-sound/jack-audio-connection-kit-0.120.0 )
	ladspa? ( media-libs/liblrdf )
	lash? ( virtual/liblash )
	oss? ( media-sound/oss )
	portaudio? ( >=media-libs/portaudio-19_pre )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-sound/pulseaudio )
	rubberband? ( media-libs/rubberband )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog DEVELOPERS README.txt )

src_configure()
{
	local mycmakeargs=(
		$(cmake-utils_use_want alsa ALSA)
		$(cmake-utils_use_want archive LIBARCHIVE)
		$(cmake-utils_use_want debug DEBUG)
		$(cmake-utils_use_want jack JACK)
		$(cmake-utils_use_want jack-session JACKSESSION)
		$(cmake-utils_use_want ladspa LRDF)
		$(cmake-utils_use_want lash LASH)
		$(cmake-utils_use_want oss OSS)
		$(cmake-utils_use_want portaudio PORTAUDIO)
		$(cmake-utils_use_want portmidi PORTMIDI)
		$(cmake-utils_use_want pulseaudio PULSEAUDIO)
		$(cmake-utils_use_want rubberband RUBBERBAND)
		$(cmake-utils_use_no static SHARED)
	)
	cmake-utils_src_configure
}
