# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-libs/serd/serd-0.18.2.ebuild,v 1.2 2014/10/14 21:08:17 -tclover Exp $

EAPI=5

inherit multilib-minimal waf-utils

DESCRIPTION="Library for RDF syntax which supports reading and writing Turtle and NTriples"
HOMEPAGE="http://drobilla.net/software/serd/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc static static-libs test utils"
REQUIRED_USE=" static? ( utils )"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS NEWS README )

src_prepare()
{
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
	epatch_user
	multilib_copy_sources
}

multilib_src_configure()
{
	local -a mywafargs=(
		"--docdir=${EPREFIX}/usr/share/doc/${PF}"
		$(use doc && echo '--docs')
		$(use static && echo '--static-progs')
		$(use static-libs && echo '--static')
		$(use test && echo '--test')
		$(use utils || echo '--no-utils')
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

