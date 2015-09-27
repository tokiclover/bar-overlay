# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-video/vapoursynth-plugins-zimg/vapoursynth-plugins-zimg-9999.ebuild,v 1.1 2015/09/24 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/sekrit-twc/${PN##*-}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/sekrit-twc/${PN##*-}/archive/prerelease-${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="Format (resize-bitdepth-colorspace) conversion plugin for VapourSynth"
HOMEPAGE="https://github.com/sekrit-twc/zimg"

LICENSE="WTFPL-2"
SLOT="0"
IUSE="debug"

RDEPEND="media-video/vapoursynth:="
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README.md )
AUTOTOOLS_AUTORECONF=1
S="${WORKDIR}/${PN##*-}-prerelease-${PV}"

src_configure()
{
	local -a myeconfargs=(
		${EXTRA_ZIMG_CONF}
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
