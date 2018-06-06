# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
inherit autotools-multilib ${VCS_ECLASS}

DESCRIPTION="Constant Time Median Filtering plugin for VapourSynth ported from Avisynth"
HOMEPAGE="https://github.com/HomeOfVapourSynthEvolution/VapourSynth-CTMF"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=( README.md )

multilib_src_configure()
{
	local -a myeconfargs=(
		--libdir="/usr/$(get_libdir)/vapoursynth"
	)
	autotools-utils_src_configure
}
