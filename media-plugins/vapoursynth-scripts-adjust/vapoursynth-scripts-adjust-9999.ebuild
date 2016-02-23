# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-video/vapoursynth-scripts-adjust/vapoursynth-scripts-adjust-9999.ebuild,v 1.1 2015/09/24 Exp $

EAPI=5
PYTHON_COMPAT=( python3_{3,4} )
PYTHON_REQ_USE='threads(+)'

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/dubhater/${PN/-scripts}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/dubhater/${PN/-scripts}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="Tweak filter plugin for VapourSynth ported from Avisynth"
HOMEPAGE="https://github.com/dubhater/vapoursynth-adjust"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="media-video/vapoursynth"
DEPEND="${RDEPEND}"

DOCS=( readme.rst )
AUTOTOOLS_AUTORECONF=1

src_install()
{
	exeinto /usr/$(get_libdir)/vapoursynth/scripts
	doexe adjust.py
	dodoc "${DOCS[@]}"
}
