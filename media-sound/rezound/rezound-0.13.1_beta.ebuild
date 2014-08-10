# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/rezound/rezound-0.13.1-beta.ebuild,v 1.2 2014/08/08 22:31:21 -tclover Exp $

EAPI=5

inherit autotools-utils flag-o-matic

DESCRIPTION="Sound editor and recorder"
HOMEPAGE="http://rezound.sourceforge.net"

SRC_URI="http://sourceforge.net/projects/${PN}/files/ReZound/${PVR/_/}/${PN}-${PVR/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="16bittmp +alsa +fftw flac +jack ladspa nls oss portaudio pulseaudio +soundtouch static vorbis"

RDEPEND="|| ( ( x11-libs/qt-core:4 x11-libs/qt-gui:4 )
				x11-libs/qt:4 )
	fftw? ( sci-libs/fftw:3.0 )
	ladspa? ( >=media-libs/ladspa-sdk-1.12
			>=media-libs/ladspa-cmt-1.15 )
	>=media-libs/audiofile-0.2.2
	alsa? ( >=media-libs/alsa-lib-1.0 )
	flac? ( >=media-libs/flac-1.1.2[cxx] )
	jack? ( media-sound/jack-audio-connection-kit )
	oss? ( media-sound/oss )
	portaudio? ( >=media-libs/portaudio-18 )
	pulseaudio? ( media-sound/pulseaudio )
	soundtouch? ( >=media-libs/libsoundtouch-1.3.1 )
	vorbis? ( media-libs/libvorbis media-libs/libogg )"

DEPEND="${RDEPEND}
	nls? ( virtual/libintl )
	dev-util/pkgconfig"

DOCS=(
	docs/AUTHORS
	docs/FEATURES
	docs/FrontendFoxFeatures.txt
	docs/README
	docs/NEWS
	docs/TODO_FOR_USERS_TO_READ
	docs/code/AudioIO
	docs/code/ClipboardEditing
	docs/code/Crossfading
	docs/code/FileManagement
	docs/code/PlayPauseLEDs
	docs/code/SoundFileFormats
	docs/code/TheActiveSoundWindow
	docs/code/WaveformRendering
	docs/code/actions
)

PATCHES=(
	"${FILESDIR}/${P}-gcc43.patch"
	"${FILESDIR}/${P}-qt44.patch"
	"${FILESDIR}/${P}-missing_includes.patch"
	"${FILESDIR}/${P}-O2.patch"
	"${FILESDIR}/0001-fix-ladspa-path.patch"
	"${FILESDIR}/0002-add-support-for-fftw3.patch"
	"${FILESDIR}/0003-autotools-patch.patch"
	"${FILESDIR}/0004-pkg-config-and-the-audiofile-library.patch"
)

src_configure() {
	local myeconfargs=(
		$(use_enable alsa)
		$(use_enable jack)
		$(use_enable ladspa)
		$(use_enable nls)
		$(use_enable oss)
		$(use_enable portaudio)
		$(use_enable pulseaudio pulse)
		$(use_enable flac)
		$(use_enable soundtouch soundtouch-check)
		$(use_enable static standalone)
		$(use_enable vorbis )
		$(use 16bittmp && echo "--enable-internal-sample-type=int16" ||
		echo "--enable-internal-sample-type=float")
		$(use_enable amd64 largefile)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	newicon src/images/icon_logo_32.png rezound.png
	domenu packaging/generic_rpm/kde/rezound.desktop
}
