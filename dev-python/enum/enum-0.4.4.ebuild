# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: dev-python/enum/enum-0.4.4.ebuild,v 1.1 2015/03/18 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Robust enumerated type support in Python."
HOMEPAGE="http://pypi.python.org/pypi/enum/"
SRC_URI="mirror://pypi/e/${PN}/${P}.tar.gz"

IUSE=""
REQUIRED_USE="${PTHON_REQUIRED_USE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
