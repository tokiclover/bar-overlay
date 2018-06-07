# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="VapourSynth-TDeintMod"
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
inherit autotools-multilib ${VCS_ECLASS}

DESCRIPTION="TDeint and TMM plugin for VapourSynth ported from Avisynth"
HOMEPAGE="https://github.com/HomeOfVapourSynthEvolution/VapourSynth-TDeintMod"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

multilib_src_configure()
{
	local -a myeconfargs=(
		${EXTRA_TDEINTMOD_CONF}
		--libdir="${EPREFIX}/usr/$(get_libdir)/vapoursynth"
	)
	autotools-utils_src_configure
}
multilib_src_install_all()
{
	dodoc README.md
}
