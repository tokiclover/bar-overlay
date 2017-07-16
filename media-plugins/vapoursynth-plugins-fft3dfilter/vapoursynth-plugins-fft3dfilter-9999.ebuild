# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/vapoursynth-plugins-fft3dfilter/vapoursynth-plugins-fft3dfilter-9999.ebuild,v 1.2 2016/05/12 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/VFR-maniac/VapourSynth-FFT3DFilter.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/VFR-maniac/VapourSynth-FFT3DFilter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit multilib-minimal ${VCS_ECLASS}

DESCRIPTION="3D Frequency Domain filter plugin for VapourSynth ported from AviSynth"
HOMEPAGE="https://github.com/VFR-maniac/VapourSynth-FFT3DFilter http://avisynth.org.ru/fft3dfilter/fft3dfilter.html"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

RDEPEND="sci-libs/fftw:3.0=[${MULTILIB_USEDEP}]
	media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
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
		${EXTRA_FFT3DFILTER_CONF}
		$(usex debug '--enable-debug' '')
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
