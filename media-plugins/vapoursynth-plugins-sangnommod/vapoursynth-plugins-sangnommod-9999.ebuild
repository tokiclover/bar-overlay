# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="VapourSynth-SangNomMod"
case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/HomeOfVapourSynthEvolution/${MY_PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/HomeOfVapourSynthEvolution/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit multilib-minimal ${VCS_ECLASS}

DESCRIPTION="Single field deinterlacer plugin for VapourSynth ported from Avisynth"
HOMEPAGE="https://github.com/HomeOfVapourSynthEvolution/VapourSynth-SangNomMod"

LICENSE="MIT"
SLOT="0"
IUSE="debug"

RDEPEND="media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare()
{
	epatch_user
	sed -e 's/-O[0-3s]//g' -e "s/clang++/$(getCXX)/g" -i configure
	multilib_copy_sources
}
multilib_src_configure()
{
	chmod +x configure
	local -a myeconfargs=(
		${EXTRA_SANGNOMMOD_CONF}
		$(usex debug '--enable-debug' '')
		--extra-cxxflags="${CXXFLAGS}"
		--extra-ldflags="${LDFLAGS}"
		--target-os="${CHOST}"
	)
	echo configure "${myeconfargs[@]}"
	./configure "${myeconfargs[@]}"
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
