# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/vapoursynth-plugins-rawsource/vapoursynth-plugins-rawsource-9999.ebuild,v 1.2 2015/10/01 Exp $

EAPI=5

MY_PN="vsrawsource"
case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/chikuzen/${MY_PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/chikuzen/${MY_PN}/archive/r${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit multilib-minimal ${VCS_ECLASS}

DESCRIPTION="RAW source decoder plugin for VapourSynth"
HOMEPAGE="https://github.com/chikuzen/vsrawsource"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug"

RDEPEND="media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"


src_prepare()
{
	epatch_user
	sed -e 's/-O[0-3s]//g' -i configure
	multilib_copy_sources
}
multilib_src_configure()
{
	chmod +x configure
	local conf=(./configure
		${EXTRA_RAWSOURCE_CONF}
		$(usex debug '--enable-debug' '')
		--extra-cflags=\"${CXXFLAGS}\"
		--extra-ldflags=\"${LDFLAGS}\"
		--target-os="${CHOST}"
	)
	echo "${conf[@]}"
	eval "${conf[@]}"
}
multilib_src_compile()
{
	emake -f GNUmakefile CXX="$(tc-getCXX)" LD="$(tc-getCXX)"
}
multilib_src_install()
{
	exeinto /usr/$(get_libdir)/vapoursynth
	doexe libvsrawsource.so*
}
multilib_src_install_all()
{
	dodoc readme.rst
}
