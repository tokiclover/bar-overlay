# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-sound/hydrogen/hydrogen-9999.ebuild,v 2012/11/09 17:46:51 -tclover Exp $

EAPI=4

inherit eutils multilib subversion

DESCRIPTION="Linux Drum Machine"
HOMEPAGE="http://hydrogen.sourceforge.net/"

ESVN_REPO_URI="http://svn.assembla.com/svn/hydrogen/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug flac jack ladspa lash portaudio"
REQUIRED_USE="lash? ( alsa )"

RDEPEND="x11-libs/qt-core:4 x11-libs/qt-gui:4
	dev-libs/libxml2
	media-libs/libsndfile
	media-libs/audiofile
	dev-libs/libtar
	portaudio? ( >=media-libs/portaudio-18.1 )
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( media-libs/liblrdf )
	lash? ( || ( media-sound/ladish media-sound/lash ) )
	flac? ( media-libs/flac )"

DEPEND="${RDEPEND}"

src_compile() {
	# export qt4 related environ (copy 'n paste fromt qt4.eclass)
	export QTDIR=/usr/$(get_libdir)
	export QMAKE=/usr/bin/qmake
	export QMAKE_CC=$(tc-getCC)
	export QMAKE_CXX=$(tc-getCXX)
	export QMAKE_LINK=$(tc-getCXX)
	export QMAKE_CFLAGS_RELEASE="${CFLAGS}"
	export QMAKE_CFLAGS_DEBUG="${CFLAGS}"
	export QMAKE_CXXFLAGS_RELEASE="${CXXFLAGS}"
	export QMAKE_CXXFLAGS_DEBUG="${CXXFLAGS}"
	export QMAKE_LFLAGS_RELEASE="${LDFLAGS}"
	export QMAKE_LFLAGS_DEBUG="${LDFLAGS}"

	local myconf="prefix=${ROOT}usr DESTDIR=${D}"
	! use alsa; myconf="${myconf} alsa=$?"
	! use debug; myconf="${myconf} debug=$?"
	! use jack; myconf="${myconf} jack=$?"
	! use ladspa; myconf="${myconf} lrdf=$?"
	! use portaudio; myconf="${myconf} portaudio=$?"
	! use lash; myconf="${myconf} lash=$?"
	! use flac; myconf="${myconf} flac=$?"

	tc-export CC CXX
	myconf="${myconf} CC=${CC} CXX=${CXX}"
	mkdir -p "${D}"
	einfo "${myconf}"
	scons CUSTOMCCFLAGS="${CFLAGS}" CUSTOMCXXFLAGS="${CXXFLAGS}" \
		MAKEOPTS="${MAKEOPTS}" \
		${myconf} || die "scons failed"
}

src_install() {
	scons install prefix="${ROOT}usr" DESTDIR="${D}" || die "scons install failed"

	# install tools
	for i in hydrogenSynth hydrogenPlayer; do
		dobin extra/$i/$i
	done
}
