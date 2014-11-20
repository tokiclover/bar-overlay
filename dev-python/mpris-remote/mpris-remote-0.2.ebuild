# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-python/mpris-remote/mpris-remote-0.2.ebuild,v 2014/09/09 -tclover Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="utility that controls an MPRIS-2 compliant music player"
HOMEPAGE="https://github.com/tokiclover/mpris-remote"
SRC_URI="https://github.com/tokiclover/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/dbus-python[${PYTHON_USEDEP}]"

src_install() {
	python_convert_shebangs -r 2 "${ED}"
	insinto /usr/bin
	insopts -m0755
	doins ${PN}
}
