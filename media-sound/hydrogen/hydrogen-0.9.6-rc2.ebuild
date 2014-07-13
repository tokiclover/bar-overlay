# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/hydrogen/hydrogen-0.9.6.ebuild,v 2014/07/07 09:53:01 -tclover Exp $

EAPI=5

inherit eutils cmake-utils multilib flag-o-matic toolchain-funcs

DESCRIPTION="Advanced drum machine"
HOMEPAGE="http://www.hydrogen-music.org"
SRC_URI="mirror://github.com/${PN}-music/${PN}/archive/${PVR/rc/RC}.tar.gz"

LICENSE="GPL-2 ZLIB"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="+alsa +archive debug doc +jack jacksession ladspa lash oss portaudio portmidi
-puleseaudio rubberband static"
REQUIRED_USE="lash? ( alsa )"

RDEPEND="archive? ( app-arch/libarchive )
	!archive? ( >=dev-libs/libtar-1.2.11-r3 )
	>=media-libs/libsndfile-1.0.18
	alsa? ( media-libs/alsa-lib )
	jack? ( >=media-sound/jack-audio-connection-kit-0.120.0 )
	ladspa? ( media-libs/liblrdf )
	oss? ( media-sound/oss )
	lash? ( || ( media-sound/ladish media-sound/lash ) )
	portaudio? ( >=media-libs/portaudio-19_pre )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-sound/pulseaudio )
	rubberband? ( media-libs/rubberband )"

DEPEND="${RDEPEND}
	dev-qt/qtgui:4 dev-qt/qtcore:4
	>=media-libs/libsndfile-1.0.18
	virtual/pkgconfig"

src_configure() {
	use ladspa && append-flags $($(tc-getPKG_CONFIG) --cflags lrdf)
	export QTDIR="/usr/$(get_libdir)"

	mycmakeargs=(
		$(use alsa && echo "-DWANT_ALSA=1" || echo "-DWANT_ALSA=0")
		$(use archive && echo "-DWANT_LIBARCHIVE=1" || echo "-DWANT_LIBARCHIVE=0"
		$(use debug && echo "-DWANT_DEBUG=1" || echo "-DWANT_DEBUG=0")
		$(use jack && echo "-DWANT_JACK=1" || echo "-DWANT_JACK=0")
		$(use jacksession && echo "-DWANT_JACKSESSION" || echo "-DWANT_JACKSESSION=0")
		$(use ladspa && echo "-DWANT_LRDF=1" || echo "-DWANT_LRDF=0")
		$(use lash && echo "-DWANT_LASH=1" || echo "-DWANT_LASH=0")
		$(use oss && echo "-DWANT_OSS=1" || echo "-DWANT_OSS=0")
		$(use portaudio && echo "-DWANT_PORTAUDIO=1" || echo "-DWANT_PORTAUDIO=0")
		$(use portmidi && echo "-DWANT_PORTMIDI=1" || echo "-DWANT_PORTMIDI=0")
		$(use pulseaudio && echo "-DWANT_PULSEAUDIO=1" || echo "-DWANT_PULSEAUDIO=0")
		$(use rubberband && echo "-DWANT_RUBBERBAND=1" || echo "-DWANT_RUBBERBAND=0")
		$(use static && echo "-DWANT_SHARED=0" || echo "-DWANT_SHARED=1")
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_comple
	use doc && emake doc
}

src_install() {
	cmake-utils_src_install
	insinto /usr/share/hydrogen
	doins -r data
	doicon data/img/gray/h2-icon.svg
	domenu linux/hydrogen.desktop
	dosym /usr/share/hydrogen/data/doc /usr/share/doc/${PF}/html
	dodoc AUTHORS ChangeLog README.txt
}
