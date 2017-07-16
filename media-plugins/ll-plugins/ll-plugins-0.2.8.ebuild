# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/ll-plugins/ll-plugins-0.2.8.ebuild,v 1.3 2015/06/06 18:00:06 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://git.sv.gnu.org/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.bz2"
		;;
esac
inherit flag-o-matic eutils multilib-minimal toolchain-funcs ${VCS_ECLASS}

DESCRIPTION="collection of LV2 plugins, LV2 extension definitions, and LV2 related tools"
HOMEPAGE="http://ll-plugins.nongnu.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=media-sound/jack-audio-connection-kit-0.109.0[${MULTILIB_USEDEP}]
	>=dev-cpp/gtkmm-2.8.8
	>=dev-cpp/cairomm-0.6.0
	virtual/liblash[${MULTILIB_USEDEP}]
	>=media-libs/liblo-0.22
	>=sci-libs/gsl-1.8
	>=media-libs/libsndfile-1.0.16[${MULTILIB_USEDEP}]
	dev-util/lv2-c++-tools"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README )

PATCHES=(
	"${FILESDIR}"/${P}-lv2-c++-tools-include.patch
	"${FILESDIR}"/${P}-Makefile.patch
)

src_prepare()
{
	epatch "${PATCHES[@]}"
	epatch_user
	multilib_copy_sources
}

multilib_src_configure()
{
	if [[ "$(tc-get-compiler-type)" = "gcc" ]] &&
	(( $(gcc-major-version 5) >= 5 )); then
		append-cxxflags -std=gnu++11
	fi
	tc-export CC CXX

	local myeconfargs=(
		#--CFLAGS="${CFLAGS}"
		#--LDFLAGS="${LDFLAGS}"
		--prefix="${EPREFIX}"/usr
	)
	ECONF_SOURCE="${BUILD_DIR}" econf "${myeconfargs[@]}"
}

multilib_src_install_all()
{
	mv -f "${ED}"/usr/share/doc/{${PN},${PF}}
}
