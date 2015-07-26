# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-python/mpris-remote/mpris-remote-0.2.ebuild,v 2015/07/26 -tclover Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="https://github.com/tokiclover/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit python-single-r1 ${VCS_ECLASS}

DESCRIPTION="utility that controls an MPRIS-2 compliant music player"
HOMEPAGE="https://github.com/tokiclover/mpris-remote"

LICENSE="CC0-1.0"
SLOT="0"
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
