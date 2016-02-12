# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/laditools/laditools-1.0_rc2.ebuild,v 1.2 2016/02/08 14:40:05 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://repo.or.cz/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~ppc ~x86"
		VCS_ECLASS=vcs-snapshot
		SRC_URI="https://launchpad.net/laditools/${PV:0:3}/${PV}/+download/${PN}-${PVR/_/-}.tar.bz2"
		;;
esac
inherit distutils-r1 ${VCS_ECLASS}

DESCRIPTION="LADITools is a set of tools to improve desktop integration and user workflow of Linux audio systems"
HOMEPAGE="http://www.marcochapeau.org/software/laditools"

LICENSE="GPL-3"
SLOT="0"
IUSE="lash"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pyxml[${PYTHON_USEDEP}]
	>=media-sound/jack-audio-connection-kit-0.109.2-r2[dbus]
	lash? ( virtual/liblash )
	x11-libs/vte"
DEPEND="${RDEPEND}"

DOCS=( README )

PATCHES=(
	"${FILESDIR}"/${P}-no_extra_docs.patch
)

pkg_preinst()
{
	use wmaker || find "${ED}" -name 'wmladi*' -exec rm '{}' + || die
}

