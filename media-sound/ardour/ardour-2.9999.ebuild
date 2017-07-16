# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/ardour/ardour-2.9999.ebuild,v 1.12 2015/06/06 18:21:28 Exp $

EAPI=5

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://git.ardour.org/ardour/ardour.git"
		EGIT_PROJECT="${PN}.git"
		EGIT_BRANCH=2.0-ongoing
		;;
	(*)
		KEYWORDS="~amd64 ~ppc ~x86"
		SRC_URI="https://github.com/Ardour/ardour/archive/${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit eutils toolchain-funcs fdo-mime flag-o-matic versionator ${VCS_ECLASS}

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"

LICENSE="GPL-2"
SLOT="${PV:0:1}"
IUSE="curl debug nls lv2"

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
	curl? ( net-misc/curl )
	lv2? (
		>=media-libs/slv2-0.6.1
		media-libs/lilv
		media-libs/suil
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( virtual/libintl )"

PATCHES=(
		"${FILESDIR}"/${PN}-2.8.11-flags.patch
		"${FILESDIR}"/${PN}-2.8.14-syslibs.patch
		"${FILESDIR}"/${PN}-2.8.14-boost-150.patch
)

src_prepare()
{
	epatch "${PATCHES[@]}"
	epatch_user
}

src_compile()
{
	tc-export CC CXX
	mkdir -p "${D}"

	local -a mysconsargs=(
		"DESTDIR=${D}"
		'PREFIX=/usr'
		'SYSLIBS=1'
		$(use_scons curl FREESOUND)
		$(use_scons debug DEBUG)
		$(use_scons nls NLS)
		$(use_scons lv2 LV2)
	)
	escons "${mysconsargs[@]}"
}

src_install()
{
	escons install

	doman ${PN}.1
	newicon icons/icon/ardour_icon_mac.png ${PN}.png
	make_desktop_entry ardour2 ardour2 ardour AudioVideo
}

