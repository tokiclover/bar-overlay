# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-python/pyrocore/pyrocore-0.4.2.ebuild,v 1.1 2014/11/11 -tclover Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="PyroScope - Python Torrent Tools Core Package"
HOMEPAGE="https://code.google.com/p/pyroscope/ https://pypi.python.org/pypi/pyrocore/"
SRC_URI="https://pypi.python.org/packages/source/p/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-plugins/screenlets"
DEPEND="dev-python/pyrobase[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

src_install()
{
	distutils-r1_src_install
	rm -fr "${ED}"/usr/EGG-INFO
}

