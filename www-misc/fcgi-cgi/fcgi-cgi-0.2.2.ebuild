# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: www-misc/fcgi-cgi/fcgi-cgi-0.2.2.ebuild,v 1.1 2016/11/20 Exp $

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
		SRC_URI="http://git.lighttpd.net/${PN}.git/snapshot/${P}.tar.gz"
		;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="FastCGI application to run cgi applications"
HOMEPAGE="https://redmine.lighttpd.net/projects/fcgi-cgi/wiki"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="dev-libs/libev
	>=dev-libs/glib-2.16.0:2"
RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=yes
