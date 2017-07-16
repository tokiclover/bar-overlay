# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/vapoursynth-plugins-ctmf/vapoursynth-plugins-ctmf-9999.ebuild,v 1.2 2015/10/01 Exp $

EAPI=5

MY_PN="VapourSynth-CTMF"
case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/HomeOfVapourSynthEvolution/${MY_PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/HomeOfVapourSynthEvolution/${MY_PN}/archive/r${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit multilib-minimal ${VCS_ECLASS}

DESCRIPTION="Constant Time Median Filtering plugin for VapourSynth ported from Avisynth"
HOMEPAGE="https://github.com/HomeOfVapourSynthEvolution/VapourSynth-CTMF"

LICENSE="GPL-2"
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
	./configure \
		${EXTRA_CTMF_CONF} \
		$(usex debug '--enable-debug' '') \
		--extra-cxxflags="${CXXFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		--install="${EPREFIX}/usr/$(get_libdir)/vapoursynth" \
		--target-os="${CHOST}"
}
multilib_src_compile()
{
	emake -f GNUmakefile CXX="$(tc-getCXX)" LD="$(tc-getCXX)"
}
multilib_src_install()
{
	emake -f GNUmakefile libdir="${ED}/usr/$(get_libdir)/vapoursynth" install
}
multilib_src_install_all()
{
	dodoc README.md
}
