# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-video/zimg/zimg-9999.ebuild,v 1.1 2015/09/24 Exp $

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
IUSE="debug static-libs +vapoursynth"

RDEPEND="vapoursynth? ( media-video/vapoursynth )"
DEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF=1

multilib_src_prepare()
{
	autotools-utils_src_prepare
	multilib_copy_sources
}
multilib_src_configure()
{
	local -a myeconfargs=(
		${EXTRA_ZIMG_CONF}
		$(use_enable debug)
		$(use_enable !static-libs shared)
	)
	autotools-utils_src_configure
}
multilib_src_install()
{
	autotools-utils_src_install
	use vapoursynth && dosym /usr/$(get_libdir)/{,vapoursynth/}libzimg.so
}
multilib_src_install_all()
{
	dodoc ChangeLog README.md
}
