# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/ll-plugins/ll-plugins-9999.ebuild,v 1.2 2014/10/10 18:00:06 -tclover Exp $

EAPI=5

inherit eutils multilib-minimal git-2

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
	virtual/liblash
	>=media-libs/liblo-0.22
	>=sci-libs/gsl-1.8
	>=media-libs/libsndfile-1.0.16
	dev-util/lv2-c++-tools"

RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README )

PATCHES=(
	"${FILESDIR}"/${P}-lv2-c++-tools-include.patch
)
src_prepare()
{
	sed -e 's/lv2cxx_common/lv2-c++-tools/' -i \
		plugins/control2midi/control2midi.cpp \
		plugins/arpeggiator/arpeggiator.cpp \
		plugins/sineshaper/sineshaper.cpp \
		plugins/beep/beep_gtk.cpp \
		plugins/beep/beep.cpp \
		plugins/klaviatur/klaviatur.cpp || die

	epatch "${PATCHES[@]}"
	epatch_user
	multilib_copy_sources
}

multilib_src_configure()
{
	local myeconfargs=(
		--CFLAGS="${CFLAGS}"
		--LDFLAGS="${LDFLAGS}"
		--prefix="${EPREFIX}"/usr
	)
	ECONF_SOURCE="${BUILD_DIR}" econf "${myeconfargs[@]}"
}

multilib_src_install_all()
{
	mv -f "${ED}"/usr/share/doc/{${PN},${PF}}
}
