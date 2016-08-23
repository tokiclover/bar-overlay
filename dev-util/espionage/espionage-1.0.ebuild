# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-python/espionage/espionage-9999.ebuild,v 1.2 2015/06/08 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_{2,3,4}} )
PYTHON_REQ_USE='xml(+)'

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://git.enlightenment.org/apps/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		AUTOTOOLS_AUTORECONF=1
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P/_/-}.tar.gz"
		;;
esac
inherit distutils-r1 ${VCS_ECLASS}

DESCRIPTION="PyEFL D-Bus inspector"
HOMEPAGE="http://enlightenement.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc"

RDEPEND=">=dev-python/python-efl-1.8.0
	dev-python/dbus-python[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

DOCS=( ChangeLog README )
