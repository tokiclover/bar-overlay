# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/vapoursynth-plugins-tnlmeans/vapoursynth-plugins-tnlmeans-9999.ebuild,v 1.2 2016/05/12 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/VFR-maniac/VapourSynth-TNLMeans.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/VFR-maniac/VapourSynth-TNLMeans/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit multilib-minimal ${VCS_ECLASS}

DESCRIPTION="NL-means denoising plugin for VapourSynth ported from AviSynth"
HOMEPAGE="https://github.com/VFR-maniac/VapourSynth-TNLMeans"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare()
{
	epatch_user
	sed -e 's/-O[s0]//g' -i configure
	multilib_copy_sources
}
multilib_src_configure()
{
	chmod +x configure
	local -a myeconfargs=(
		${EXTRA_TNLMEANS_CONF}
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
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
	emake -f GNUmakefile libdir="${ED}/usr/$(get_libdir)" install
}
multilib_src_install_all()
{
	dodoc README
}
