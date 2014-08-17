# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/deadbeef-plugins-jack/deadbeef-plugins-mpris-9999.ebuild,v 1.1 2014/08/16 14:43:14 -tclover Exp $

EAPI=5

inherit autotools-utils git-2

DESCRIPTION="MPRIS plugin for DeaDBeeF music player"
HOMEPAGE="http://deadbeef-mpris.sourceforge.net/"
EGIT_REPO_URI="git://ihacklog.com/DeaDBeeF-MPRIS-plugin.git"
EGIT_PROJECT=${PN}.git

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="media-sound/deadbeef
	sys-apps/dbus
	${DEPEND}"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=modules
AUTOTOOLS_IN_SOURCE_BUILD=1

