# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-sound/rezound/rezound-9999.ebuild,v 1.0 2012/11/02 22:31:21 -tclover Exp $

EAPI="2"

inherit eutils autotools flag-o-matic subversion

DESCRIPTION="Sound editor and recorder"
HOMEPAGE="http://rezound.sourceforge.net"

ESVN_REPO_URI="https://rezound.svn.sourceforge.net/svnroot/rezound/branches/rezound/qt4-port"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="16bittmp alsa doc flac jack ladspa nls oss portaudio soundtouch vorbis"

RDEPEND="|| ( ( x11-libs/qt-core x11-libs/qt-gui )
				x11-libs/qt:4 )
	sci-libs/fftw:3.0
	ladspa? ( >=media-libs/ladspa-sdk-1.12
			>=media-libs/ladspa-cmt-1.15 )
	>=media-libs/audiofile-0.2.2
	alsa? ( >=media-libs/alsa-lib-1.0 )
	flac? ( >=media-libs/flac-1.1.2[cxx] )
	jack? ( media-sound/jack-audio-connection-kit )
	portaudio? ( >=media-libs/portaudio-18 )
	soundtouch? ( >=media-libs/libsoundtouch-1.3.1 )
	vorbis? ( media-libs/libvorbis media-libs/libogg )"

DEPEND="${RDEPEND}
	doc? ( sys-devel/gettext
		virtual/libintl )
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc43.patch"
	epatch "${FILESDIR}/${P}-qt44.patch"
	epatch "${FILESDIR}/${P}-missing_includes.patch"
	epatch "${FILESDIR}/${P}-O2.patch"
	epatch "${FILESDIR}/0001-fix-ladspa-path.patch"
	epatch "${FILESDIR}/0002-add-support-for-fftw3.patch"
	epatch "${FILESDIR}/0003-autotools-patch.patch"
	epatch "${FILESDIR}/0004-pkg-config-and-the-audiofile-library.patch"

	#AT_M4DIR="config/m4" eautoreconf
	./bootstrap || die
}

src_configure() {
	# following features can't be disabled if already installed:
	# -> flac, oggvorbis, soundtouch <-- why not? I've added missing flags
	local sampletype="--enable-internal-sample-type=float"
	use 16bittmp && sampletype="--enable-internal-sample-type=int16"

	# -O3 isn't safe wrt #275437
	replace-flags -O[3-9] -O2

	econf \
		$(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable ladspa) \
		$(use_enable nls) \
		$(use_enable oss) \
		$(use_enable portaudio) \
		$(use_enable flac) \
		$(use_enable soundtouch soundtouch-check) \
		$(use_enable vorbis ) \
		${sampletype} \
		--enable-largefile \
		|| die "configure failed"
}

src_compile() {
	emake -j1 || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# remove wrong doc directory
	rm -rf "${D}/usr/doc"

	dodoc docs/{AUTHORS,NEWS,README*}
	dodoc docs/{TODO_FOR_USERS_TO_READ,*.txt}
	newdoc README README.rezound

	docinto code
	dodoc docs/code/*
	newicon share/images/icon_logo_32.png rezound.png
	make_desktop_entry "rezound" "Rezound" "rezound" "AudioVideo;Audio;Recorder"
}
