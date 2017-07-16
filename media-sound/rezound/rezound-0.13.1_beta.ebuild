# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/rezound/rezound-0.13.1-beta.ebuild,v 1.3 2014/10/10 22:31:21 Exp $

EAPI=5
PLOCALES="cs de es fi fr ru"

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=subversion
		ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}/code/trunk/${PN}"
		AUTOTOOLS_AUTORECONF=1
		;;
	(*)
		KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
		MY_PVR="${PVR%-r*}"
		SRC_URI="http://sourceforge.net/projects/${PN}/files/ReZound/${PVR/_/}/${PN}-${MY_PVR/_/}.tar.gz"
		S="${WORKDIR}/${PN}-${MY_PVR/_/}"
		unset MY_PVR
		;;
esac
inherit l10n autotools-utils flag-o-matic ${VCS_ECLASS}

DESCRIPTION="Sound editor and recorder"
HOMEPAGE="http://rezound.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
IUSE="16bittmp +alsa +fftw flac +jack ladspa nls oss portaudio pulseaudio +soundtouch static vorbis"

RDEPEND=">=x11-libs/fox-1.1.0:1.6
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
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/fix-ladspa-path.patch"
	"${FILESDIR}/undefined-function.patch"
)

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure()
{
	local linguas
	use nls && linguas="$(l10n_get_locales)"
	echo "${linguas}" >po/LINGUAS

	export WANT_FOX=1.6
	use static && export AC_DISABLE_SHARED=1

	local -a myeconfargs=(
		'--disable-rpath'
		'--enable-fftw3'
		$(use_enable alsa)
		$(use_enable jack)
		$(use_enable ladspa)
		$(use_enable nls)
		$(use_enable oss)
		$(use_enable portaudio)
		$(use_enable pulseaudio pulse)
		$(use static && echo '--enable-standalone')
		$(use 16bittmp && echo '--enable-internal-sample-type=int16' ||
		echo '--enable-internal-sample-type=float')
		$(use_enable amd64 largefile)
	)
	PKG_CONFIG="$(which pkg-config)" autotools-utils_src_configure
}

src_install()
{
	autotools-utils_src_install

	rm -f docs/COPYING && dodoc -r docs/*
	rm -f -r "${ED}"/usr/doc
}

