# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/laditools/laditools-1.0_rc2.ebuild,v 1.2 2014/08/08 14:40:05 -tclover Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1

DESCRIPTION="LADITools is a set of tools to improve desktop integration and user workflow of Linux audio systems"
HOMEPAGE="http://www.marcochapeau.org/software/laditools"
SRC_URI="http://www.marcochapeau.org/files/${PN}/${PN}-${PVR/_/-}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lash"

RDEPEND="dev-python/pygtk
	dev-python/pyxml
	>=media-sound/jack-audio-connection-kit-0.109.2-r2[dbus]
	lash? ( virtual/liblash )
	x11-libs/vte"

DEPEND="dev-lang/python"

DOCS=( README )

PATCHES=(
	"${FILESDIR}"/${P}-no_extra_docs.patch
)

S="${WORKDIR}"/${PN}-${PVR/_/-}

pkg_preinst() {
	use wmaker || find "${D}" -name 'wmladi*' -exec rm '{}' + || die
}

