# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-plugins/ll-plugins/ll-plugins-0.2.8.ebuild,v 2012/11/09 18:00:06 -tclover Exp $

inherit multilib

DESCRIPTION="collection of LV2 plugins, LV2 extension definitions, and LV2 related tools"
HOMEPAGE="http://ll-plugins.nongnu.org"
SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.109.0
	>=dev-cpp/gtkmm-2.8.8
	>=dev-cpp/cairomm-0.6.0
	|| ( >=media-sound/ladish-1 >=media-sound/lash-0.5.1 )
	>=media-libs/liblo-0.22
	>=sci-libs/gsl-1.8
	>=media-libs/libsndfile-1.0.16
	dev-util/lv2-c++-tools"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# ar doesn't really like ldflags
	sed -e 's:ar rcs $$@ $$^ $(LDFLAGS) $$($(2)_LDFLAGS):ar rcs	$$@ $$^:' \
		-i Makefile.template || die
}

src_compile(){
	econf \
		--prefix=/usr \
		--CFLAGS="${CFLAGS} `pkg-config --cflags slv2`" \
		--LDFLAGS="${LDFLAGS} `pkg-config --libs slv2`" \
		|| die "configure failed"
	emake || die "make failed"
}

src_install(){
	emake DESTDIR="${D}" libdir="/usr/$(get_libdir)" install || die "install failed"
}
