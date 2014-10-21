# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-libs/ganv/ganv-1.4.2.ebuild,v 1.5 2014/10/10 08:45:11 -tclover Exp $

EAPI=5

inherit toolchain-funcs multilib-minimal waf-utils

DESCRIPTION="An interactive Gtk widget for boxes and lines or graph-like environments"
HOMEPAGE="http://drobilla.net/software/ganv/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug graphviz introspection nls"

RDEPEND="dev-libs/boost
	x11-libs/gtk+:2
	>=dev-cpp/gtkmm-2.11.12:2.4
	>=dev-cpp/glibmm-2.14:2
	graphviz? ( media-gfx/graphviz )
	introspection? ( dev-libs/gobject-introspection )"

DEPEND="${RDEPEND}
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

