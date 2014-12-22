# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-python/python-efl/python-efl-1.12.0.ebuild,v 1.1 2014/12/22 -tclover Exp $

EAPI=5

PYTHON_COMPAT=( python{2_{6,7},3_{2,3}} )

inherit distutils-r1 git-2

DESCRIPTION="Python bindings for the EFL"
HOMEPAGE="http://enlightenement.org"
EGIT_REPO_URI="git.enlightenment.org/bindings/python/${PN}.git"

LICENSE="GPL-3 LGPL-3"
SLOT="0/${PV:0:4}"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-libs/efl-${PV:0:4}
	>=dev-python/cython-0.19.1"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README TODO )
