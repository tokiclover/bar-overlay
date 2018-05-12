# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
inherit autotools-multilib ${VCS_ECLASS}

DESCRIPTION="Text output plugin for VapourSynth"
HOMEPAGE="https://github.com/dubhater/vapoursynth-scrawl"

LICENSE="LGPL-2.1 OFL-1.1"
SLOT="0"
IUSE=""

RDEPEND="media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	app-portage/elt-patches
	media-fonts/terminus-font"

AUTOTOOLS_AUTORECONF=1

multilib_src_configure()
{
	local -a myeconfargs=(
		${EXTRA_SCRAWL_CONF}
		--libdir="${EPREFIX}/usr/$(get_libdir)/vapoursynth"
	)
	autotools-utils_src_configure
}
multilib_src_install_all()
{
	dodoc readme.rst
}
