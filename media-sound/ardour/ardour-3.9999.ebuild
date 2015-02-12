# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/ardour/ardour-3.9999.ebuild,v 1.10 2015/02/10 18:21:28 -tclover Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE='threads(+)'

inherit eutils toolchain-funcs flag-o-matic python-any-r1 waf-utils git-2

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="http://ardour.org/"
EGIT_REPO_URI="git://git.ardour.org/ardour/ardour.git"
EGIT_COMMIT=${PV}

LICENSE="GPL-2"
SLOT="3"
IUSE="altivec debug doc nls lv2 sse"

RDEPEND="media-libs/aubio
	media-libs/liblo
	sci-libs/fftw:3.0
	media-libs/freetype:2
	>=dev-libs/glib-2.10.1:2
	dev-cpp/glibmm:2
	>=x11-libs/gtk+-2.8.1:2
	>=dev-libs/libxml2-2.6:2
	>=media-libs/libsndfile-1.0.18
	>=media-libs/libsamplerate-0.1
	>=media-libs/rubberband-1.6.0
	>=media-libs/libsoundtouch-1.6.0
	media-libs/flac
	media-libs/raptor:2
	>=media-libs/liblrdf-0.4.0-r20
	>=media-sound/jack-audio-connection-kit-0.120
	>=gnome-base/libgnomecanvas-2
	media-libs/vamp-plugin-sdk
	dev-libs/libxslt
	dev-libs/libsigc++:2
	>=dev-cpp/gtkmm-2.16:2.4
	>=dev-cpp/libgnomecanvasmm-2.26:2.6
	media-libs/alsa-lib
	x11-libs/pango
	x11-libs/cairo
	media-libs/libart_lgpl
	virtual/libusb:0
	dev-libs/boost
	>=media-libs/taglib-1.7
	net-misc/curl
	lv2? (
		>=media-libs/slv2-0.6.1
		media-libs/lilv
		media-libs/sratom
		dev-libs/sord
		>=media-libs/suil-0.6.10
		>=media-libs/lv2-1.4.0
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	nls? ( virtual/libintl )
	doc? ( app-doc/doxygen[dot] )"

src_prepare()
{
	PVTEMP="${PV}"

	sed -e "s/rev = .*('utf-8')/rev = \'${PVTEMP}\'/g" \
		-e "s/FLAGS', optimization_flags/FLAGS', ''/g" \
		-i "${S}"/wscript
	sed 's/python/python3/' -i waf

	epatch_user
}

src_configure()
{
	tc-export CC CXX
	mkdir -p "${D}"

	local -a mywafargs=(
		"--destdir=${D}"
		"--prefix=${EPREFIX}/usr"
		"--configdir=${EPREFIX}/etc"
		"--libdir=${EPREFIX}/usr/$(get_libdir)"
		$(use lv2 && echo '--lv2' || echo '--no-lv2')
		$(use nls && echo '--nls' || echo '--no-nls')
		$(use debug && echo '--stl-debug' || echo '--optimize')
		$($(use altivec || use sse) && echo '--fpu-optimization' || echo '--no-fpu-optimization')
		$(use doc && echo '--docs')
	)
	CCFLAGS="${CFLAGS}" LINKFLAGS="${CFLAGS} ${LDFLAGS}" ./waf \
		configure "${mywafargs[@]}" || die "Failed to configure"
}

src_compile()
{
	./waf --jobs=$(makeopts_jobs) || die "Failed to compile"
}

src_install()
{
	./waf --destdir="${ED}" || die "Failed to install"

	mv ${PN}.1 ${PN}${SLOT}.1
	doman ${PN}${SLOT}.1
	newicon icons/icon/ardour_icon_mac.png ${PN}${SLOT}.png
	make_desktop_entry ardour3 ardour3 ardour3 AudioVideo
}

pkg_postinst()
{
	elog "If you are using Ardour and want to keep its development alive"
	elog "then please consider to do a donation upstream at ardour.org. Thanks!"
}

