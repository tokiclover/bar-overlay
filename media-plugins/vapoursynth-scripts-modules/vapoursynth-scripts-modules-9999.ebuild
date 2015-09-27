# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-video/vapoursynth-scripts-modules/vapoursynth-scripts-modules-9999.ebuild,v 1.1 2015/09/24 Exp $

EAPI=5
PYTHON_COMPAT=( python3_{3,4} )
PYTHON_REQ_USE='threads(+)'

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/4re/${PN/-scripts}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/4re/${PN/-scripts}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="Collection of VapourSynth modules ported from Avisynth scripts"
HOMEPAGE="https://github.com/4re/vapoursynth-modules"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="media-video/vapoursynth"
DEPEND="${RDEPEND}"

DOCS=( README.md )
AUTOTOOLS_AUTORECONF=1
S="${WORKDIR}/${PN/-scripts}-${PV}"

src_install()
{
	exeinto /usr/$(get_libdir)/vapoursynth/scripts
	doexe *.py
	dodoc "${DOCS[@]}"
}
