# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/laditools/laditools-9999.ebuild,v 1.1 2014/07/22 14:40:09 -tclover Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-2

DESCRIPTION="Control and monitor a LADI system the easy way"
HOMEPAGE="https://launchpad.net/laditools"
EGIT_REPO_URI="git://repo.or.cz/laditools.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="lash wmaker ${PYTHON_REQUIRED_USE}"

RDEPEND="lash? ( virtual/liblash )
    x11-libs/gtk+:3[introspection]
	>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	>=dev-python/enum-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.0.0[${PYTHON_USEDEP}]
	dev-python/pyxml[${PYTHON_USEDEP}]
	wmaker? ( dev-python/wmdocklib )
	>=x11-libs/gtk+-3.0.0[introspection]
	x11-libs/vte[introspection]
	>=media-sound/jack-audio-connection-kit-0.109.2-r2[dbus]"

DEPEND="dev-python/python-distutils-extra[${PYTHON_USEDEP}]"


DOCS="README NEWS"

pkg_preinst() {
		find "${D}" -name 'wmladi*' -exec rm '{}' + || die
}
