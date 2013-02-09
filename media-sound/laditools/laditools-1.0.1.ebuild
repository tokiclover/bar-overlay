# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-sound/laditools/laditools-1.0.ebuild,v 1.0 2012/12/10 14:40:00 -tclover Exp $

EAPI=5

PYTHON_COMPAT="python2_7"

inherit eutils distutils

DESCRIPTION="Control and monitor a LADI system the easy way"
HOMEPAGE="https://launchpad.net/laditools"
SRC_URI="https://launchpad.net/laditools/${PV:0:3}/${PV}/+download/${PN}-${PVR/_/-}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="lash"

DEPEND="dev-python/python-distutils-extra"

RDEPEND=">=dev-python/enum-0.4.4
	dev-python/pygtk
	dev-python/pyxml
	>=media-sound/jack-audio-connection-kit-0.109.2-r2[dbus]
	dev-python/pygobject:3
    x11-libs/gtk+:3[introspection]
	x11-libs/vte:2.90[introspection]
	lash? ( media-sound/ladish )"

DOCS="README"

pkg_setup() {
	python_set_active_version 2.7
	python_pkg_setup
}

#src_prepare() {
#	epatch "${FILESDIR}/${P}-rsvg.patch"
#}
