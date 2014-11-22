# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-python/pyrobase/pyrobase-0.2.ebuild,v 1.1 2014/11/11 -tclover Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="PyroScope - General Python Helpers and Utilities"
HOMEPAGE="https://code.google.com/p/pyroscope/ https://pypi.python.org/pypi/pyrobase/"
SRC_URI="http://pypi.python.org/packages/source/p/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools"

src_install()
{
	distutils-r1_src_install
	rm -fr "${ED}"/usr/EGG-INFO
}

