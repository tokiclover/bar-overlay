# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-libs/ganv/ganv-1.4.2.ebuild,v 1.7 2015/06/01 08:45:11 Exp $

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
inherit toolchain-funcs python-any-r1 waf-utils multilib-minimal ${VCS_ECLASS}

DESCRIPTION="An interactive Gtk widget for boxes and lines or graph-like environments"
HOMEPAGE="http://drobilla.net/software/ganv/"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug graphviz introspection nls"

RDEPEND="dev-libs/boost
	x11-libs/gtk+:2
	>=dev-cpp/gtkmm-2.11.12:2.4
	>=dev-cpp/glibmm-2.14:2
	graphviz? ( media-gfx/graphviz )
	introspection? ( dev-libs/gobject-introspection )"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	nls? ( virtual/libintl )
	virtual/pkgconfig"

DOCS=( AUTHORS README NEWS )

src_prepare()
{
	default
	multilib_copy_sources
}

multilib_src_configure()
{
	local -a mywafargs=(
		--prefix="${EPREFIX}/usr"
		$(use debug && echo '--debug')
		$(use graphviz || echo '--no-graphviz')
		$(use introspection && echo '--gir')
		$(use nls || echo '--no-nls')
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

