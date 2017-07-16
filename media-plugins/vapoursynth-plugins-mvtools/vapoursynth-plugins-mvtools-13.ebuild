# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/vapoursynth-plugins-mvtools/vapoursynth-plugins-mvtools-9999.ebuild,v 1.2 2015/10/01 Exp $

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

DESCRIPTION="MVTools (Motion compensation and estimation filters) plugin for VapourSynth ported from Avisynth"
HOMEPAGE="https://github.com/dubhater/vapoursynth-mvtools"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="media-video/vapoursynth:=[${MULTILIB_USEDEP}]
	sci-libs/fftw:3.0=[${MULTILIB_USEDEP}]"
DEPEND="dev-lang/yasm
	${RDEPEND}"

AUTOTOOLS_AUTORECONF=1

multilib_src_configure()
{
	local -a myeconfargs=(
		${EXTRA_MVTOOLS_CONF}
		--libdir="${EPREFIX}/usr/$(get_libdir)/vapoursynth"
	)
	autotools-utils_src_configure
}
multilib_src_install_all()
{
	dodoc readme.rst
}
