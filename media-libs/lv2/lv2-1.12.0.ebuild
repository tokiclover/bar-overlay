# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-libs/lv2/lv2-1.12.0.ebuild,v 1.3 2016/05/10 12:16:47 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )
PYTHON_REQ_USE='threads(+)'

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://lv2plug.in/git/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	;;
	(*)
	KEYWORDS="~amd64 ~ppc ~x86"
	VCS_ECLASS=vcs-snapshot
	SRC_URI="http://lv2plug.in/spec/${P}.tar.bz2"
	;;
esac
inherit multilib-minimal python-any-r1 waf-utils ${VCS_ECLASS}

DESCRIPTION="LV2 is a simple but extensible successor of LADSPA"
HOMEPAGE="http://lv2plug.in/"

LICENSE="MIT"
SLOT="0"
IUSE="doc plugins test"

DEPEND="plugins? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}]
	media-libs/libsndfile[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}
	!<media-libs/slv2-0.4.2
	!media-libs/lv2core
	!media-libs/lv2-ui"
DEPEND="${DEPEND}
	${PYTHON_DEPS}
	plugins? ( virtual/pkgconfig )
	doc? ( app-doc/doxygen dev-python/rdflib )"

DOCS=( README.md NEWS )

src_prepare()
{
	epatch_user
	multilib_copy_source
}

multilib_src_configure()
{
	local -a mywafargs=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use test    && echo '--test')
		$(use plugins || echo '--no-plugins')
		$(use doc     && echo '--online-docs')
	)
	WAF_BINARY="${BUILD_DIR}" waf-utils_src_configure "${mywafargs[@]}"
}

multilib_src_compile()
{
	WAF_BINARY="${BUILD_DIR}" waf-utils_src_compile
}

multilib_src_install()
{
	WAF_BINARY="${BUILD_DIR}" waf-utils_src_install
}

