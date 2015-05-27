# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-python/python-efl/python-efl-1.12.0.ebuild,v 1.2 2015/05/22 -tclover Exp $

EAPI=5
PYTHON_COMPAT=( python{2_{6,7},3_{2,3}} )

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://git.enlightenment.org/bindings/python/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	case "${PV}" in
		(*.9999*) EGIT_BRANCH="${PN}-${PV:0:4}";;
	esac
	AUTOTOOLS_AUTORECONF=1
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://download.enlightenment.org/rel/bindings/python/${PN}/${P/_/-}.tar.xz"
	;;
esac
inherit distutils-r1 ${VCS_ECLASS}

DESCRIPTION="Python bindings for the EFL"
HOMEPAGE="http://enlightenement.org"

LICENSE="GPL-3 LGPL-3"
SLOT="0/${PV:0:4}"
IUSE="doc"

RDEPEND=">=dev-libs/efl-${PV:0:4}
	>=dev-python/cython-0.19.1"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	virtual/pkgconfig"

DOCS=( AUTHORS README TODO )
