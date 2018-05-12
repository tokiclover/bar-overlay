# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_{3,4}} )

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://git.enlightenment.org/apps/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P/_/-}.tar.gz"
		;;
esac
inherit distutils-r1 ${VCS_ECLASS}

DESCRIPTION="EFL bittorent client"
HOMEPAGE="https://www.enlightenment.org https://phab.enlightenment.org/w/projects/epour"

IUSE=""
LICENSE="BSD-2"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="dev-python/python-efl[${PYTHON_USEDEP}]
	>=net-libs/rb_libtorrent-1.0
	sys-apps/dbus
	x11-misc/xdg-utils
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README TODO )
