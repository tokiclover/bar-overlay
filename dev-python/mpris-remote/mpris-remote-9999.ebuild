# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-python/mpris-remote/mpris-remote-9999.ebuild,v 2014/08/16 -tclover Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 git-2

DESCRIPTION="utility that controls an MPRIS-2 compliant music player"
HOMEPAGE="https://github.com/tokiclover/mpris-remote"
EGIT_REPO_URI="git://github.com/tokiclover/mpris-remote.git"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS=""
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/dbus-python[${PYTHON_USEDEP}]"

src_install()
{
	insinto /usr/bin
	insopts -m0755
	doins ${PN}
}
