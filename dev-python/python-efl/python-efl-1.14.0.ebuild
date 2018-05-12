# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_{6,7},3_{3,4,5}} )

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
	SRC_URI="https://download.enlightenment.org/rel/bindings/python/${P/_/-}.tar.bz2"
	;;
esac
inherit distutils-r1 ${VCS_ECLASS}

DESCRIPTION="Python bindings for the EFL"
HOMEPAGE="http://enlightenement.org"

LICENSE="GPL-3 LGPL-3"
SLOT="0/${PV:0:4}"
IUSE="doc"

RDEPEND=">=dev-libs/efl-${PV:0:4}
	>=dev-python/cython-0.19.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	virtual/pkgconfig
	${PTHON_DEPS}"

DOCS=( AUTHORS ChangeLog README )
