# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-video/vapursynth/vapursynth-9999.ebuild,v 1.1 2015/09/24 Exp $

EAPI=5
MY_PN="Wobbly"
case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/dubhater/${MY_PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/dubhater/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit eutils autotools-utils ${VCS_ECLASS}

DESCRIPTION="IVTC video processing assistant for VapourSynth similar to Yatta"
HOMEPAGE="https://github.com/dubhater/Wobbly"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug python +vapoursynth-pipe +vapoursynth-script"

RDEPEND="dev-qt/qtcore:5 dev-qt/qtwidgets:5
		media-video/vapoursynth:=[vapoursynth-script]
		>=media-plugins/vapoursynth-plugins-fieldhint-3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

AUTOTOOLS_AUTORECONF=1
DOCS=( readme.rst )
