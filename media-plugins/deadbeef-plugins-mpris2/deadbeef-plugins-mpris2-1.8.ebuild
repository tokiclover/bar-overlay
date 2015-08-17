# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/deadbeef-plugins-mpris2/deadbeef-plugins-mpris2-9999.ebuild,v 1.2 2015/08/16 14:43:14 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/Serranya/deadbeef-mpris2-plugin.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~x86"
		SRC_URI="https://github.com/Serranya/deadbeef-mpris2-plugin/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/deadbeef-mpris2-plugin-${PV}"
		;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="MPRISv2 plugin for DeaDBeeF music player"
HOMEPAGE="https://github.com/Serranya/deadbeef-mpris2-plugin"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="media-sound/deadbeef
	sys-apps/dbus
	${DEPEND}"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=modules
AUTOTOOLS_IN_SOURCE_BUILD=1
