# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-video/vapoursynth-scripts-havsfunc/vapoursynth-scripts-havsfunc-9999.ebuild,v 1.1 2016/04/24 Exp $

EAPI=5
PYTHON_COMPAT=( python3_{3,4} )
PYTHON_REQ_USE='threads(+)'

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/HomeOfVapourSynthEvolution/${PN/#*-scripts-}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/HomeOfVapourSynthEvolution/${PN/#*-scripts-}/archive/r${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="Holy's ported AviSynth functions for VapourSynth"
HOMEPAGE="https://github.com/HomeOfVapourSynthEvolution/havsfunc"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="media-video/vapoursynth
	media-plugins/vapoursynth-scripts-adjust
	media-plugins/vapoursynth-scripts-mvsfunc"
DEPEND="${RDEPEND}"

src_install()
{
	insinto /usr/$(get_libdir)/vapoursynth/scripts
	doins havsfunc.py
}
