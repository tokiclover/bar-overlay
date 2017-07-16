# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-video/d2vwitch/d2vwitch-9999.ebuild,v 1.1 2015/09/24 Exp $

EAPI=5
MY_PN="D2VWitch"

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/dubhater/${MY_PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/dubhater/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit eutils autotools-utils ${VCS_ECLASS}

DESCRIPTION="Cross-platform D2V creator"
HOMEPAGE="https://github.com/dubhater/D2VWitch"

LICENSE="LGPL-2.1 ISC"
SLOT="0"
IUSE=""

RDEPEND=">=virtual/ffmpeg-9"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

AUTOTOOLS_AUTORECONF=1
DOCS=( readme.rst )

src_install()
{
	autotools-utils_src_install
	mv "${ED}"/usr/bin/{${MY_PN},${PN}}
}
