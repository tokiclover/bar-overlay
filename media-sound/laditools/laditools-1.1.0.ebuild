# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/laditools/laditools-1.1.0.ebuild,v 1.3 2016/04/04 14:40:00 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/alessio/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~ppc ~x86"
		VCS_ECLASS=vcs-snapshot
		SRC_URI="https://github.com/alessio/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit distutils-r1 ${VCS_ECLASS}

DESCRIPTION="Linux Audio Desktop Integration Tools"
HOMEPAGE="https://github.com/LADI/laditools https://github.com/alessio/laditools"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="lash wmaker"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="lash? ( virtual/liblash )
    x11-libs/gtk+:3[introspection]
	>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	!dev-python/enum[${PYTHON_USEDEP}] virtual/python-enum34[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.0.0[${PYTHON_USEDEP}]
	dev-python/pyxml[${PYTHON_USEDEP}]
	wmaker? ( dev-python/wmdocklib[${PYTHON_USEDEP}] )
	>=x11-libs/gtk+-3.0.0[introspection]
	x11-libs/vte[introspection]
	>=media-sound/jack-audio-connection-kit-0.109.2-r2[dbus]"
DEPEND="dev-python/python-distutils-extra[${PYTHON_USEDEP}]"

DOCS=( AUTHORS ChangeLog NEWS README.md )
PATCHES=(
	"${FILESDIR}"/python-enum34.patch
)

pkg_preinst()
{
	use wmaker || find "${ED}" -name 'wmladi*' -exec rm '{}' + || die
}
