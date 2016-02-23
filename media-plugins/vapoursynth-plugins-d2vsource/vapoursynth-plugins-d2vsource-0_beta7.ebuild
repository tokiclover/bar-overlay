# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-video/vapoursynth-plugins-d2vsource/vapoursynth-plugins-d2vsource-9999.ebuild,v 1.2 2015/10/01 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/dwbuiten/${PN##*-}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/dwbuiten/${PN##*-}/archive/${PV#*_}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit multilib-minimal ${VCS_ECLASS}

DESCRIPTION="D2V source decoder plugin for VapourSynth"
HOMEPAGE="https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Yadifmod"

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
	./configure \
		${EXTRA_TDEINTMOD_CONF} \
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
	dodoc README
}
