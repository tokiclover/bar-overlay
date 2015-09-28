# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-libs/ffms2/ffms2-9999.ebuild,v 1.2 2015/09/28 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/FFMS/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/FFMS/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit autotools-multilib ${VCS_ECLASS}

DESCRIPTION="FFmpeg(/LibAV)Source decoder wrapper library"
HOMEPAGE="https://github.com/FFMS/ffms2"

LICENSE="GPL-3 MIT"
SLOT="0"
IUSE="debug static-libs +vapoursynth"

RDEPEND="|| ( >=media-libs/libav-11:=[${MULTILIB_USEDEP}]
		>=media-video/ffmpeg-2.4.0:=[${MULTILIB_USEDEP}] )
		vapoursynth? ( media-video/vapoursynth )
		sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

AUTOTOOLS_AUTORECONF=1

multilib_src_prepare()
{
	sed -rne 's/-O[0-3]//g' -i configure.ac
	autotools-utils_src_prepare
	multilib_copy_sources
}
multilib_src_configure()
{
	local -a myeconfargs=(
		${EXTRA_FFMS_CONF}
		$(use_enable debug)
		$(use_enable !static-libs shared)
	)
	autotools-utils_src_configure
}
multilib_src_install()
{
	autotools-utils_src_install
	use vapoursynth && dosym /usr/$(get_libdir)/{,vapoursynth/}libffms2.so
}
multilib_src_install_all()
{
	dodoc README.md doc/ffms2-avisynth.md etc/FFMS2.avsi
}
