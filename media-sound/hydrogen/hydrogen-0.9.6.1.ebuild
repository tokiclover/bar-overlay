# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/hydrogen/hydrogen-0.9.6.ebuild,v 1.4 2015/06/08 11:53:01 Exp $

EAPI=5

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/hydrogen-music/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="amd64 ppc ppc64 x86"
		VCS_ECLASS=vcs-snapshot
		SRC_URI="https://github.com/${PN}-music/${PN}/archive/${PVR/_/-}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit eutils cmake-utils multilib flag-o-matic toolchain-funcs ${VCS_ECLASS}

DESCRIPTION="Advanced drum machine"
HOMEPAGE="http://www.hydrogen-music.org"

LICENSE="GPL-2 ZLIB"
SLOT="0"
IUSE="+alsa +archive debug doc +jack jack-session ladspa lash oss portaudio portmidi
-pulseaudio rubberband static"
REQUIRED_USE="lash? ( alsa )"

RDEPEND="archive? ( app-arch/libarchive )
	!archive? ( >=dev-libs/libtar-1.2.11-r3 )
	doc? ( app-doc/doxygen )
	dev-qt/qtgui:4 dev-qt/qtcore:4
	dev-qt/qtxmlpatterns:4
	>=media-libs/libsndfile-1.0.18
	alsa? ( media-libs/alsa-lib )
	jack? ( >=media-sound/jack-audio-connection-kit-0.120.0 )
	ladspa? ( media-libs/liblrdf )
	oss? ( media-sound/oss )
	lash? ( virtual/liblash )
	portaudio? ( >=media-libs/portaudio-19_pre )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-sound/pulseaudio )
	rubberband? ( media-libs/rubberband )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog DEVELOPERS README.txt )

S="${WORKDIR}/${PN}-${PVR/_rc/-RC}"

src_configure()
{
	sed -e 's/-O2 //g' -i CMakeLists.txt
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
