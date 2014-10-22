# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/laditools/laditools-1.0.ebuild,v 1.2 2014/10/10 14:40:00 -tclover Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Control and monitor a LADI system the easy way"
HOMEPAGE="https://launchpad.net/laditools"
SRC_URI="https://launchpad.net/laditools/${PV:0:3}/${PV}/+download/${PN}-${PVR/_/-}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="lash wmaker ${PYTHON_REQUIRED_USE}"

RDEPEND="lash? ( virtual/liblash )
    x11-libs/gtk+:3[introspection]
	>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	>=dev-python/enum-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.0.0[${PYTHON_USEDEP}]
	dev-python/pyxml[${PYTHON_USEDEP}]
	wmaker? ( dev-python/wmdocklib[${PYTHON_USEDEP}] )
	>=x11-libs/gtk+-3.0.0[introspection]
	x11-libs/vte[introspection]
	>=media-sound/jack-audio-connection-kit-0.109.2-r2[dbus]"

DEPEND="dev-python/python-distutils-extra[${PYTHON_USEDEP}]"

DOCS=( README )

pkg_preinst()
{
	use wmaker || find "${ED}" -name 'wmladi*' -exec rm '{}' + || die
}
