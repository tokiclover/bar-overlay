# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/vapoursynth-plugins-lsmashsource/vapoursynth-plugins-lsmashsource-9999.ebuild,v 1.2 2016/05/12 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/VFR-maniac/L-SMASH-Works.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/VFR-maniac/L-SMASH-Works/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit multilib-minimal ${VCS_ECLASS}

DESCRIPTION="(FFmpeg) Libavcodec-SMASH Source plugin for VapourSynth"
HOMEPAGE="https://github.com/VFR-maniac/L-SMASH-Works http://avisynth.nl/index.php/LSMASHSource"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="media-video/l-smash:=[${MULTILIB_USEDEP}]
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
	pushd VapourSynth
	chmod +x configure
	local -a myeconfargs=(
		${EXTRA_LSMASHSOURCE_CONF}
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		--extra-cflags="${CFLAGS}"
		--extra-ldflags="${LDFLAGS}"
		--target-os="${CHOST}"
	)
	echo configure "${myeconfargs[@]}"
	./configure "${myeconfargs[@]}"
	popd
}
multilib_src_compile()
{
	emake -C VapourSynth -f GNUmakefile CC="$(tc-getCC)" LD="$(tc-getCC)"
}
multilib_src_install()
{
	emake -C VapourSynth -f GNUmakefile DESTDIR="${ED}" install
}
multilib_src_install_all()
{
	dodoc VapourSynth/README
}
