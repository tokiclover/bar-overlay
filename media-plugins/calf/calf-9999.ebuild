# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/calf/calf-9999.ebuild,v 1.2 2015/03/30 00:38:38 Exp $

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://github.com/calf-studio-gear/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	AUTOTOOLS_AUTORECONF=1
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="Audio plug-in pack (instrument and effects) for LV2 and JACK"
HOMEPAGE="http://calf-studio-gear.org/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug +lash lv2 static-libs"

RDEPEND="dev-libs/expat
	dev-libs/glib:2
	gnome-base/libglade:2.0
	media-sound/fluidsynth
	>=media-sound/jack-audio-connection-kit-0.105.0
	sci-libs/fftw:3.0
	x11-libs/gtk+:2
	lash? ( virtual/liblash )
	lv2? ( >=media-libs/lv2-1.0.0 )"
DEPEND="${RDEPEND} virtual/pkgconfig"

DOCS=(AUTHORS ChangeLog NEWS README TODO)

ATOTOOL_IN_SOURCE_BUILD=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=modules

src_configure()
{
	local -a myeconfargs=(
		${CALF_EXTRA_CONF}
		$(use_enable debug)
		$(use_with lash)
		$(use_with lv2)
		$(usex lv2 "--with-lv2-dir=${EPREFIX}/usr/$(get_libdir)/lv2")
	)
	autotools-utils_src_configure
}
