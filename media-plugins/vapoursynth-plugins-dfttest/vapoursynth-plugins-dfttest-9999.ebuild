# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-video/vapoursynth-plugins-bm3d/vapoursynth-plugins-bm3d-9999.ebuild,v 1.1 2015/09/24 Exp $

EAPI=5

MY_PN="VapourSynth-BM3D"
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
		;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="BM3D denoising filter plugin for VapourSynth ported from Avisynth"
HOMEPAGE="https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug"

RDEPEND="sci-libs/fftw:3
	media-video/vapoursynth:="
DEPEND="${RDEPEND}"

DOCS=( README.md )
S="${WORKDIR}/${MY_PN}-r${PV}"

src_prepare()
{
	epatch_user
}
src_configure()
{
	./configure \
		${EXTRA_BM3D_CONF} \
		$(usex debug '--enable-debug' '') \
		--extra-cxxflags="${CXXFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		--install="${EPREFIX}/usr/$(get_libdir)/vapoursynth" \
		--target-os="${CHOST}"
}
src_compile()
{
	emake
}
src_install()
{
	emake -f GNUmakefile libdir="${ED}/usr/$(get_libdir)/vapoursynth" install
	dodoc "${DOCS[@]}"
}
