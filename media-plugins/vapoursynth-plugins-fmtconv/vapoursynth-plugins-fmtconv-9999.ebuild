# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/vapoursynth-plugins-fmtconv/vapoursynth-plugins-fmtconv-9999.ebuild,v 1.2 2016/04/25 22:08:33 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/EleonoreMizo/fmtconv/${PN/#*-plugins-}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/EleonoreMizo/${PN/#*-plugins-}/archive/r${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit autotools-multilib ${VCS_ECLASS}

DESCRIPTION="Format Conversion Tools plugin for VapourSynth"
HOMEPAGE="https://github.com/EleonoreMizo/fmtconv"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

src_prepare()
{
	mv build/unix/{Makefile.am,configure.ac} .
	sed -e 's:\.\./\.\./::g' -i Makefile.am
	epatch_user
	multilib_copy_sources
	autotools-utils_src_prepare
}
multilib_src_configure()
{
	local -a myeconfargs=(
		${EXTRA_FMTCONV_CONF}
		--libdir="${EPREFIX}/usr/$(get_libdir)/vapoursynth"
	)
	autotools-utils_src_configure
}
multilib_src_install_all()
{
	dohtml doc/${PN#*-plugins-}.html
}
