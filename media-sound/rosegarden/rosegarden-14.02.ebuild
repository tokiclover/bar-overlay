# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/rosegarden/rosegarden-14.02.ebuild,v 1.2 2015/06/08 23:15:32 -radhermit Exp $

EAPI=5

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=subversion
		ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}/code/trunk/${PN}"
		AUTOTOOLS_AUTORECONF=1
		;;
	(*)
		KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
		SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.bz2"
		;;
esac
inherit eutils autotools-multilib fdo-mime gnome2-utils ${VCS_ECLASS}

DESCRIPTION="MIDI and audio sequencer and notation editor"
HOMEPAGE="http://www.rosegardenmusic.com/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug lirc"

RDEPEND="dev-qt/qtgui:4
	media-libs/ladspa-sdk:=
	x11-libs/libSM:=
	media-sound/jack-audio-connection-kit:=
	media-libs/alsa-lib:=
	>=media-libs/dssi-1.0.0:=
	media-libs/liblo:=
	media-libs/liblrdf:=
	sci-libs/fftw:3.0
	media-libs/libsamplerate:=[sndfile]
	lirc? ( app-misc/lirc:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-misc/makedepend"

PATCHES=(
	"${FILESDIR}"/${PN}-12.12.25-debug.patch
)

AUTOTOOLS_AUTORECONF=1

src_prepare()
{
	autotools-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure()
{
	export USER_CXXFLAGS="${CXXFLAGS}"
	export ac_cv_header_lirc_lirc_client_h=$(usex lirc)
	export ac_cv_lib_lirc_client_lirc_init=$(usex lirc)

	local -a myeconfargs=(
		$(use_enable debug)
		--with-qtdir=/usr
		--with-qtlibdir=/usr/$(get_libdir)/qt4
	)
	autotools-utils_src_configure
}

pkg_preinst()
{
	gnome2_icon_savelist
}

pkg_postinst()
{
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm()
{
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
