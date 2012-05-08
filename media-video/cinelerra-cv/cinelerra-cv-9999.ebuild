# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-video/cinelerra-cv/cinelerra-cv-9999.ebuild,v 1.1 2011/11/16 -tclover Exp $

EAPI=3
inherit autotools eutils multilib flag-o-matic git-2

DESCRIPTION="Community Version of Cinelerra the most advanced non-linear video
editor and compositor for Linux"
HOMEPAGE="http://www.cinelerra.org/"
EGIT_REPO_URI="git://git.cinelerra.org/CinelerraCV.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="3dnow alsa altivec css ieee1394 mmx opengl oss"

RDEPEND="!media-video/${PN/-cv}
	>=media-libs/libpng-1.4.0
	>=media-libs/libdv-1.0.0
	media-libs/faad2
	media-libs/faac
	media-libs/a52dec
	media-libs/libsndfile
	media-libs/tiff
	virtual/ffmpeg
	media-sound/lame
	>=sci-libs/fftw-3.0.1
	media-libs/x264
	media-video/mjpegtools
	>=media-libs/freetype-2.1.10
	>=media-libs/openexr-1.2.2
	>=media-libs/libvorbis-1.2.3
	>=media-libs/libogg-1.1.4
	>=media-libs/libtheora-1.1.1
	>=media-libs/libdv-0.103
	x11-libs/libX11
	x11-libs/libXv
	x11-libs/libXxf86vm
	x11-libs/libXext
	x11-libs/libXvMC
	x11-libs/libXft
	virtual/jpeg
	alsa? ( >=media-libs/alsa-lib-1.0.2 )
	ieee1394? ( media-libs/libiec61883
		>=sys-libs/libraw1394-1.2.0
		>=sys-libs/libavc1394-0.5.0 )
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.57
	app-arch/xz-utils
	dev-util/pkgconfig
	mmx? ( dev-lang/nasm )"

src_prepare() {
	epatch "${FILESDIR}/${PN/-cv}-v4l1_removal.patch" \
		"${FILESDIR}/${PN/-cv}-ffmpeg.patch"
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	append-flags -D__STDC_CONSTANT_MACROS #321945

	econf \
		--disable-dependency-tracking \
		$(use_enable oss) \
		$(use_enable alsa) \
		--disable-esd \
		$(use_enable ieee1394 firewire) \
		$(use_enable css) \
		$(use_enable mmx) \
		$(use_enable 3dnow) \
		$(use_enable altivec) \
		$(use_enable opengl) \
		--with-plugindir=/usr/$(get_libdir)/cinelerra \
		--with-buildinfo=cust/"Gentoo - ${PV}" \
		--with-external-ffmpeg
}

src_install() {
	emake DESTDIR="${D}" install || die
	dohtml -a png,html,texi,sdw -r doc/*

	rm -rf "${D}"/usr/include
	mv -vf "${D}"/usr/bin/mpeg3cat{,.hv} || die
	mv -vf "${D}"/usr/bin/mpeg3dump{,.hv} || die
	mv -vf "${D}"/usr/bin/mpeg3toc{,.hv} || die
	dosym /usr/bin/mpeg2enc /usr/$(get_libdir)/cinelerra/mpeg2enc.plugin

	find "${D}" -name '*.la' -exec rm -f '{}' +
}
