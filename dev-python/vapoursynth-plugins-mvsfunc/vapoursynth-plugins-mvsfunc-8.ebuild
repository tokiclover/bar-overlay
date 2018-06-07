# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python3_{4,5,6} )
PYTHON_REQ_USE='threads(+)'

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/HomeOfVapourSynthEvolution/${PN/#*-plugins-}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/HomeOfVapourSynthEvolution/${PN/#*-plugins-}/archive/r${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit python-r1 ${VCS_ECLASS}

DESCRIPTION="mawen1250's functions for VapourSynth"
HOMEPAGE="https://github.com/HomeOfVapourSynthEvolution/mvsfunc"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="media-video/vapoursynth[${PYTHON_USEDEP}]
	media-plugins/vapoursynth-plugins-bm3d
	media-plugins/vapoursynth-plugins-fmtconv
	${PYTHON_DEPS}"
DEPEND=""

src_install()
{
	local u
	for u in "${PYTHON_COMPAT[@]}"; do
		use python_targets_${u} || continue
		insinto /usr/$(get_libdir)/${u/_/.}
		doins mvsfunc.py
	done
}
