# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: www-misc/multiwatch/multiwatch-1.0.ebuild,v 1.1 2016/11/20 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://git.lighttpd.net/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="http://download.lighttpd.net/${PN}/releases-1.x/${P}.tar.xz"
		;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="Supervise multiple instances of a process"
HOMEPAGE="http://download.lighttpd.net/multiwatch/wiki/"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="dev-libs/libev
	>=dev-libs/glib-2.16.0:2"
RDEPEND="${DEPEND}"
