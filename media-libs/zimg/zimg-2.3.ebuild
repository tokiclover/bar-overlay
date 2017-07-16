# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-video/zimg/zimg-9999.ebuild,v 1.1 2015/09/24 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/sekrit-twc/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/sekrit-twc/${PN}/archive/prerelease-${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit autotools-multilib ${VCS_ECLASS}

DESCRIPTION="Scaling, colorspace and dithering conversion library"
HOMEPAGE="https://github.com/sekrit-twc/zimg"

LICENSE="WTFPL-2"
SLOT="0"
IUSE="cpu_flags_x86_sse debug static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=yes
DOCS=( ChangeLog README.md )

multilib_src_configure()
{
	local -a myeconfargs=(
		${EXTRA_ZIMG_CONF}
		$(use_enable debug)
		$(use_enable !static-libs shared)
		$(use_enable cpu_flags_x86_sse x86simd)
	)
	autotools-utils_src_configure
}
