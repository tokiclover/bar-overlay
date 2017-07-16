# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: dev-python/pyrocore/pyrocore-0.4.2.ebuild,v 1.2 2015/07/26 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/pyroscope/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="mirror://pypi.python.org/packages/source/p/${PN}/${P}.zip"
		;;
esac
inherit distutils-r1 ${VCS_ECLASS}

DESCRIPTION="PyroScope - Python Torrent Tools Core Package"
HOMEPAGE="https://github.com/pyroscope/pyroscope/ https://pypi.python.org/pypi/pyrocore/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQIRED_USE}"

RDEPEND="x11-plugins/screenlets"
DEPEND="dev-python/pyrobase[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

src_install()
{
	distutils-r1_src_install
	rm -fr "${ED}"/usr/EGG-INFO
}
