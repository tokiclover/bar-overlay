# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="CombMask"
case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/chikuzen/${MY_PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/chikuzen/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit multilib-minimal ${VCS_ECLASS}

DESCRIPTION="Comb-mask and merge filter plugin for VapourSynth"
HOMEPAGE="https://github.com/chikuzen/CombMask"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug"

RDEPEND="media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare()
{
	epatch_user
	sed -e 's/-O[0-3s]//g' -i ${PN%%-*}/src/configure
	multilib_copy_sources
}
multilib_src_configure()
{
	pushd vapoursynth/src
	chmod +x configure
	local -a conf=(./configure \
		${EXTRA_COMBMASK_CONF} \
		$(usex debug '--enable-debug' '') \
		--extra-cflags=\"${CXXFLAGS}\" \
		--extra-ldflags=\"${LDFLAGS}\" \
		--install="${EPREFIX}/usr/$(get_libdir)/vapoursynth" \
		--target-os="${CHOST}"
	)
	echo "${conf[@]}"
	eval "${conf[@]}"
	popd
}
multilib_src_compile()
{
	emake -C vapoursynth/src -f GNUmakefile \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		LD="$(tc-getCXX)" STRIP="$(tc-getSTRIP)"
}
multilib_src_install()
{
	exeinto /usr/$(get_libdir)/vapoursynth
	doexe vapoursynth/src/libcombmask.so*
}
multilib_src_install_all()
{
	dodoc vapoursynth/readme.rst
}
