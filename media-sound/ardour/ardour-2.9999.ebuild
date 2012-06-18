# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs fdo-mime flag-o-matic subversion versionator

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"

ESVN_REPO_URI="http://subversion.ardour.org/svn/ardour2/branches/2.0-ongoing"
ESVN_RESTRICT="export"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="altivec debug freesound nls sse lv2 vst sys-libs"

RDEPEND=">=media-libs/liblrdf-0.4.0
	media-libs/aubio
	>=media-libs/raptor-1.4.2
	>=media-sound/jack-audio-connection-kit-0.116.2
	>=dev-libs/glib-2.10.3
	>=x11-libs/gtk+-2.8.8
	media-libs/flac
	>=media-libs/alsa-lib-1.0.14a-r1
	>=media-libs/libsamplerate-0.1.1-r1
	media-libs/liblo
	>=dev-libs/libxml2-2.6.0
	dev-libs/libxslt
	media-libs/vamp-plugin-sdk
	=sci-libs/fftw-3*
	freesound? ( net-misc/curl )
	lv2? ( >=media-libs/slv2-0.6.1 )
	sys-libs? ( >=dev-libs/libsigc++-2.0
		>=dev-cpp/glibmm-2.4
		>=dev-cpp/cairomm-1.0
		>=dev-cpp/gtkmm-2.8
		>=dev-libs/atk-1.6
		>=x11-libs/pango-1.4
		>=dev-cpp/libgnomecanvasmm-2.12.0
		gnome-base/libgnomecanvas
		>=media-libs/libsndfile-1.0.16
		>=media-libs/libsoundtouch-1.0 )"
		# currently internal rubberband is used
		# that needs fftw3 and vamp-sdk, but it rocks, so enable by default

DEPEND="${RDEPEND}
	sys-devel/libtool
	dev-libs/boost
	dev-util/pkgconfig
	dev-util/scons
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/ardour2"

pkg_setup(){
	einfo "this ebuild fetches from the svn maintaince"
	einfo "ardour-2.X branch"
	# issue with ACLOCAL_FLAGS if set to a wrong value
	if use sys-libs;then
		ewarn "You are trying to use the system libraries"
		ewarn "instead the ones provided by ardour"
		ewarn "No upstream support for doing so. Use at your own risk!!!"
		ewarn "To use the ardour provided libs remerge with:"
		ewarn "USE=\"-sys-libs\" emerge =${P}"

		epause 3s
	fi

	if use amd64 && use vst; then
		eerror "${P} currently does not compile with VST support on amd64!"
		eerror "Please unset VST useflag."
		die
	fi
}

src_unpack(){
	# abort if user answers no to distribution of vst enabled binaries
	if use vst; then
		agree_vst || die "you can not distribute ardour with vst support"
	fi
	subversion_src_unpack
	subversion_wc_info
	einfo "Copying working copy to source dir:"
	mkdir -p "${S}"
	cp -R "${ESVN_WC_PATH}"/* "${S}"
	cp -R "${ESVN_WC_PATH}"/.* "${S}"
	cd "${S}"

	# hack to use the sys-lib for sndlib also
#	use sys-libs && epatch "${FILESDIR}/ardour-2.0.3-sndfile-external.patch"

	add_ccache_to_scons

	ardour_vst_prepare
}

src_compile() {
	# Required for scons to "see" intermediate install location
	mkdir -p "${D}"

	local myconf=""
	(use sse || use altivec) && myconf="FPU_OPTIMIZATION=1"
	! use altivec; myconf="${myconf} ALTIVEC=$?"
	! use debug; myconf="${myconf} ARDOUR_DEBUG=$?"
	! use freesound; myconf="${myconf} FREESOUND=$?"
	! use nls; myconf="${myconf} NLS=$?"
	! use vst; myconf="${myconf} VST=$?"
	! use sys-libs; myconf="${myconf} SYSLIBS=$?"
	! use sse; myconf="${myconf} USE_SSE_EVERYWHERE=$? BUILD_SSE_OPTIMIZATIONS=$?"
	! use lv2; myconf="${myconf} LV2=$?"

	# static settings
	myconf="${myconf} DESTDIR=${D} PREFIX=/usr KSI=0"
	einfo "${myconf}"

	cd "${S}"
	scons ${myconf}	${MAKEOPTS} || die "compilation failed"
}

src_install() {
	scons install || die "make install failed"
	if use vst;then
		mv "${D}"/usr/bin/ardourvst "${D}"/usr/bin/ardour2
	fi

	dodoc DOCUMENTATION/*

	newicon "${S}/icons/icon/ardour_icon_mac.png" "ardour2.png"
	make_desktop_entry "ardour2" "Ardour2" "ardour2" "AudioVideo;Audio"
}

pkg_postinst() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update

	ewarn "---------------- WARNING -------------------"
	ewarn ""
	ewarn "MAKE BACKUPS OF THE SESSION FILES BEFORE TRYING THIS VERSION."
	ewarn ""
	ewarn "The simplest way to address this is to make a copy of the session file itself"
	ewarn "(e.g mysession/mysession.ardour) and make that file unreadable using chmod(1)."
	ewarn ""
}
