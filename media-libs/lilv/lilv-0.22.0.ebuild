# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-libs/lilv/lilv-0.18.0.ebuild,v 1.4 2015/06/01 12:22:58 Exp $

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
inherit base python-any-r1 waf-utils bash-completion-r1 ${VCS_ECLASS}

DESCRIPTION="Library to make the use of LV2 plugins as simple as possible for applications"
HOMEPAGE="http://drobilla.net/software/lilv/"

LICENSE="ISC"
SLOT="0"
IUSE="doc +dyn-manifest static static-libs test +utils"

RDEPEND="media-libs/lv2
	>=media-libs/sratom-0.4.0
	>=dev-libs/serd-0.14.0
	>=dev-libs/sord-0.12.0"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )

src_prepare()
{
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
}

src_configure()
{
	local -a mywafargs=(
		"--default-lv2-path=${EPREFIX}/usr/$(get_libdir)/lv2"
		"--docdir=${EPREFIX}/usr/share/doc/${PF}"
		'--no-bash-completion'
		$(use test && echo '--test')
		$(use doc  && echo '--docs')
		$(use static       && echo '--static-progs')
		$(use static-libs  && echo '--static')
		$(use dyn-manifest && echo '--dyn-manifest')
		$(use utils || echo '--no-utils')
	)
	waf-utils_src_configure "${mywafargs[@]}"
}

src_test()
{
	./waf test || die
}

src_install()
{
	waf-utils_src_install
	newbashcomp utils/lilv.bash_completion ${PN}
}
