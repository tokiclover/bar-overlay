# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-libs/sratom/sratom-0.4.2.ebuild,v 1.4 2015/06/01 10:13:24 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE='threads(+)'

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=subversion
	ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk/${PN}"
	ESVN_PROJECT="${PN}"
	;;
	(*)
	KEYWORDS="~amd64 ~ppc ~x86"
	SRC_URI="http://download.drobilla.net/${P}.tar.bz2"
	;;
esac
inherit python-any-r1 waf-utils multilib-minimal ${VCS_ECLASS}

DESCRIPTION="Library for serialising LV2 atoms to/from RDF, particularly the Turtle syntax"
HOMEPAGE="http://drobilla.net/software/sratom/"

LICENSE="ISC"
SLOT="0"
IUSE="doc static-libs test"

RDEPEND="media-libs/lv2[${MULTILIB_USEDEP}]
	>=dev-libs/serd-0.14.0[${MULTILIB_USEDEP}]
	>=dev-libs/sord-0.12.0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( NEWS README )

src_prepare()
{
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
	epatch_user
	multilib_copy_sources
}

multilib_src_configure()
{
	local -a mywafargs=(
		--docdir=/usr/share/doc/${PF}
		$(use test && echo '--test')
		$(use doc && echo '--docs')
		$(use static-libs && echo '--static')
	)
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_configure "${mywafargs[@]}"
}

multilib_src_compile()
{
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_compile
}

multilib_src_install()
{
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_install
}

multilib_src_test()
{
	./waf test || die
}

