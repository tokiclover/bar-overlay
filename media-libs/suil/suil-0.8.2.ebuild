# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-libs/suil/suil-0.8.0.ebuild,v 1.4 2015/06/01 12:20:50 Exp $

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

DESCRIPTION="Lightweight C library for loading and wrapping LV2 plugin UIs"
HOMEPAGE="http://drobilla.net/software/suil/"

LICENSE="ISC"
SLOT="0"
IUSE="doc gtk qt4 static-libs"

RDEPEND="media-libs/lv2
	gtk? ( x11-libs/gtk+:2 )
	qt4? ( dev-qt/qtgui:4 )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

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
		"--mandir=${EPREFIX}/usr/share/man"
		$(use doc && echo '--docs')
		$(use gtk || echo '--no-gtk')
		$(use qt4 || echo '--no-qt')
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

