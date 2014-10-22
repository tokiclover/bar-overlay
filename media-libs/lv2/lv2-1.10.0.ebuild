# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-libs/lv2/lv2-1.10.0.ebuild,v 1.2 2014/10/10 12:16:47 aballier Exp $

EAPI=5

inherit waf-utils

DESCRIPTION="LV2 is a simple but extensible successor of LADSPA"
HOMEPAGE="http://lv2plug.in/"
SRC_URI="http://lv2plug.in/spec/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc plugins test"

DEPEND="plugins? ( x11-libs/gtk+:2 media-libs/libsndfile )"
RDEPEND="${DEPEND}
	!<media-libs/slv2-0.4.2
	!media-libs/lv2core
	!media-libs/lv2-ui"
DEPEND="${DEPEND}
	plugins? ( virtual/pkgconfig )
	doc? ( app-doc/doxygen dev-python/rdflib )"

DOCS=( README NEWS )

src_configure()
{
	local -a mywafargs=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use test    && echo '--test')
		$(use plugins || echo '--no-plugins')
		$(use doc     && echo '--online-docs')
	)
	waf-utils_src_configure "${mywafargs[@]}"
}

