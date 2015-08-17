# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/deadbeef-plugins-mpris/deadbeef-plugins-mpris-9999.ebuild,v 1.2 2015/08/16 14:43:14 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://git.code.sf.net/p/deadbeef-mpris/code.git"
		EGIT_PROJECT="${PN}.git"
		AUTOTOOLS_AUTORECONF=1
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
		;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="MPRIS plugin for DeaDBeeF music player"
HOMEPAGE="http://deadbeef-mpris.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="media-sound/deadbeef
	sys-apps/dbus
	${DEPEND}"

AUTOTOOLS_PRUNE_LIBTOOL_FILES=modules
AUTOTOOLS_IN_SOURCE_BUILD=1
