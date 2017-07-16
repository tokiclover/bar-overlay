# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/vapoursynth-plugins-tcomb/vapoursynth-plugins-tcomb-9999.ebuild,v 1.2 2016/04/25 22:08:33 Exp $

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
inherit flag-o-matic autotools-multilib ${VCS_ECLASS}

DESCRIPTION="(NTSC) Temporal comb filter plugin for VapourSynth"
HOMEPAGE="https://github.com/dubhater/vapoursynth-tcomb"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	dev-lang/yasm"

AUTOTOOLS_AUTORECONF=1

src_prepare()
{
	epatch_user
	sed -e 's/-O[0-3s]//g' -i configure
	multilib_copy_sources
	autotools-utils_src_prepare
}
multilib_src_configure()
{
	append-cxxflags '-fabi-version=6'
	local -a myeconfargs=(
		${EXTRA_TCOMB_CONF}
		--libdir="${EPREFIX}/usr/$(get_libdir)/vapoursynth"
	)
	autotools-utils_src_configure
}
multilib_src_install_all()
{
	dodoc readme.rst
}
