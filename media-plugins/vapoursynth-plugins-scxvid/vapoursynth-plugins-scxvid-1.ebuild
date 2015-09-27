# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-video/vapoursynth-plugins-scxvid/vapoursynth-plugins-scxvid-9999.ebuild,v 1.1 2015/09/24 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/dubhater/${PN/-plugins}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/dubhater/${PN/-plugins}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="Scene-change detection plugin (using XviD) for VapourSynth"
HOMEPAGE="https://github.com/dubhater/vapoursynth-scxvid"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="media-libs/xvid:=
	media-video/vapoursynth:="
DEPEND="${RDEPEND}"

DOCS=( readme.rst )
AUTOTOOLS_AUTORECONF=1

src_configure()
{
	local -a myeconfargs=(
		${EXTRA_FFMS_CONF}
		--libdir="${EPREFIX}/usr/$(get_libdir)/vapoursynth"
	)
	autotools-utils_src_configure
}
