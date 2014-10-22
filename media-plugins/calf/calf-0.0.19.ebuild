# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-plugins/calf/calf-0.0.19.ebuild,v 1.1 2014/10/10 00:38:33 -tclover Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="A set of open source instruments and effects for digital audio workstations"
HOMEPAGE="http://calf.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lash lv2 sse static-libs"

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

AUTOTOOLS_PRUNE_LIBTOOL_FILES=modules

src_configure()
{
	local -a myeconfargs=(
		$(use_with lv2)
		$(use lv2 && echo "--with-lv2-dir=${EPREFIX}/usr/$(get_libdir)/lv2")
		$(use_enable sse)
	)
	autotools-utils_src_configure
}

