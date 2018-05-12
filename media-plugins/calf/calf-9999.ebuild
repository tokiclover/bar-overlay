# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://github.com/calf-studio-gear/${PN}.git"
	EGIT_PROJECT="${PN}.git"
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
IUSE="cpu_flags_x86_sse gtk jack lash lv2 static-libs experimental"

RDEPEND="dev-libs/expat
	dev-libs/glib:2
	gnome-base/libglade:2.0
	media-sound/fluidsynth
	>=media-sound/jack-audio-connection-kit-0.105.0
	sci-libs/fftw:3.0
	x11-libs/gtk+:2
	lash? ( virtual/liblash )
	lv2? ( >=media-libs/lv2-1.0.0 )"
DEPEND="${RDEPEND}
	app-portage/elt-patches
	virtual/pkgconfig"

DOCS=(AUTHORS ChangeLog NEWS README TODO)

AUTOTOOLS_AUTORECONF=1
ATOTOOL_IN_SOURCE_BUILD=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=modules

src_configure()
{
	# remove compiler flag
	sed -re 's/ -O[0-9] / /g' -i configure.ac

	local -a myeconfargs=(
		${CALF_EXTRA_CONF}
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable experimental)
		$(use_enable static-libs static)
		$(usex gtk '--with-gui' '--without-gui')
		$(usex lash '--with-lash' '--without-lash')
		$(usex lv2 '--with-lv2' '--without-lv2')
		$(usex lv2 "--with-lv2-dir=${EPREFIX}/usr/$(get_libdir)/lv2")
	)
	autotools-utils_src_configure
}
