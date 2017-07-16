# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/deadbeef-plugins-filebrowser/deadbeef-plugins-filebrowser-9999.ebuild,v 1.2 2015/08/16 14:43:14 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://gitlab.com/zykure/deadbeef-fb.git"
		EGIT_PROJECT="${PN}.git"
		AUTOTOOLS_AUTORECONF=1
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="https://gitlab.com/zykure/deadbeef-fb/raw/release/source/deadbeef-fb_${PV}_src.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="File-Browser plugin for DeaDBeeF music player"
HOMEPAGE="http://deadbeef-fb.sourceforge.net/ https://gitlab.com/zykure/deadbeef-fb"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug gtk gtk3 static-libs"
REQUIRED_USE="|| ( gtk gtk3 )"

DEPEND="gtk? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )"
RDEPEND="media-sound/deadbeef[gtk?,gtk3?]
	${DEPEND}"

AUTOTOOLS_PRUNE_LIBTOOL_FILES=modules
AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure()
{
	local -a myeconfargs=(
		${EXTRA_DDB_FB_CONF}
		$(use_enable debug)
		$(use_enable gtk gtk2)
		$(use_enable gtk3)
		$(use_enable static-libs staticlink)
	)
	autotools-utils_src_configure
}
