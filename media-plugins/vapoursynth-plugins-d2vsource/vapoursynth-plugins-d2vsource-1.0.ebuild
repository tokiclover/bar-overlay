# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/dwbuiten/${PN##*-}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/dwbuiten/${PN##*-}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit autotools-multilib ${VCS_ECLASS}

DESCRIPTION="D2V source decoder plugin for VapourSynth"
HOMEPAGE="https://github.com/dwbuiten/d2vsource/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug"

RDEPEND="media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	app-portage/elt-patches"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

multilib_src_configure()
{
	local ECONF_SOURCE="${BUILD_DIR}"
	local myeconfargs=(
		${EXTRA_D2VSOURCE_CONF}
		--libdir="${EPREFIX}/usr/$(get_libdir)/vapoursynth"
	)
	autotools-utils_src_configure
}
multilib_src_install_all()
{
	dodoc README
}
