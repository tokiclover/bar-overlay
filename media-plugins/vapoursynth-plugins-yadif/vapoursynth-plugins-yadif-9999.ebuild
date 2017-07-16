# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/vapoursynth-plugins-yadif/vapoursynth-plugins-yadif-9999.ebuild,v 1.2 2015/10/01 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/chikuzen/yadifmod2.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/chikuzen/yadifmod2/archive/${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit multilib-minimal ${VCS_ECLASS}

DESCRIPTION="Yet Another Deinterlacing Filter plugin for VapourSynth ported from Avisynth"
HOMEPAGE="https://github.com/chikuzen/yadifmod2"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

RDEPEND="media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare()
{
	epatch_user
	sed -e 's/-O[0-3s]//g' -e "s/g++/$(tc-getCXX)/g" \
		-e 's/DEPLIBS=""/DEPLIBS=vapoursynth/g' \
		-i vapoursynth/src/configure
	multilib_copy_sources
}
multilib_src_configure()
{
	pushd vapoursynth/src
	chmod +x configure
	local -a myeconfargs=(
		${EXTRA_YADIF_CONF}
		$(usex debug '--enable-debug' '')
		--extra-cxxflags="${CXXFLAGS} -fabi-version=6"
		--extra-ldflags="${LDFLAGS}"
		--target-os="${CHOST}"
		--libdir="${ED}/usr/$(get_libdir)"
	)
	echo configure "${myeconfargs[@]}"
	./configure "${myeconfargs[@]}"
	popd
}
multilib_src_compile()
{
	emake -C vapoursynth/src -f GNUmakefile CXX="$(tc-getCXX)" LD="$(tc-getCXX)"
}
multilib_src_install()
{
	emake -C vapoursynth/src -f GNUmakefile install
}
multilib_src_install_all()
{
	dodoc vapoursynth/readme.md
}
