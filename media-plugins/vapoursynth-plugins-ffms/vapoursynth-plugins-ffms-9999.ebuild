# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-video/vapoursynth-plugins-ffms/vapoursynth-plugins-ffms-9999.ebuild,v 1.1 2015/09/24 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/FFMS/ffms2.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/FFMS/ffms2/archive/${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="FFmpeg/LibAV source decoder plugin for VapourSynth"
HOMEPAGE="https://github.com/FFMS/ffms3"

LICENSE="MIT"
SLOT="0"
IUSE="debug"

RDEPEND="|| ( >=media-video/libav-11:=
		>=media-video/ffmpeg-2.4.0:= )
	media-video/vapoursynth:="
DEPEND="${RDEPEND}"

DOCS=( README.md )
AUTOTOOLS_AUTORECONF=1

src_configure()
{
	local -a myeconfargs=(
		${EXTRA_FFMS_CONF}
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
