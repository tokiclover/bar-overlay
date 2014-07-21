# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/ll-plugins/ll-plugins-9999.ebuild,v 2014/01/15 18:00:11 -tclover Exp $

EAPI="5"

inherit eutils multilib git-2

DESCRIPTION="collection of LV2 plugins, LV2 extension definitions, and LV2 related tools"
HOMEPAGE="http://ll-plugins.nongnu.org"

EGIT_REPO_URI="git://git.sv.gnu.org/ll-plugins.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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

S="${WORKDIR}/${PN}"

src_prepare() {
	# ar doesn't really like ldflags
	sed -e 's:ar rcs $$@ $$^ $(LDFLAGS) $$($(2)_LDFLAGS):ar rcs	$$@ $$^:' \
		-i Makefile.template || die
	sed -e 's/lv2cxx_common/lv2-c++-tools/' -i \
		plugins/control2midi/control2midi.cpp \
		plugins/arpeggiator/arpeggiator.cpp \
		plugins/sineshaper/sineshaper.cpp \
		plugins/beep/beep_gtk.cpp \
		plugins/beep/beep.cpp \
		plugins/klaviatur/klaviatur.cpp || die
}

src_configure(){
	 econf \
		--prefix=/usr \
		--CFLAGS="${CFLAGS} $(pkg-config --cflags slv2)" \
		--LDFLAGS="${LDFLAGS} $(pkg-config --libs slv2)"
}
