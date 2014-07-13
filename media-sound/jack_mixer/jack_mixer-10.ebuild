# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/jack_mixer/jack_mixer-10.ebuild, 2014/07/14 -tclover $

EAPI=4

inherit eutils gnome2 python

PYTHON_DEPEND="2"

DESCRIPTION="JACK audio mixer using GTK2 interface."
HOMEPAGE="http://home.gna.org/jackmixer/"
SRC_URI="mirror://download.gna.org/jackmixer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gconf lash phat"

DEPEND=">=media-sound/jack-audio-connection-kit-0.102.0
	dev-python/pygtk
	dev-python/fpconst
	>=dev-python/pyxml-0.8.4"

RDEPEND="${DEPEND}
	phat? ( media-libs/pyphat )
	gconf? ( dev-python/gconf-python:2 )
	lash? ( || (
		media-sound/ladish[python]
		media-sound/lash[python]
		>=media-libs/pylash-3_pre
		)
	)"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	gnome2_src_install
	python_convert_shebangs -r 2 "${ED}"
	dosym /usr/bin/jack_mixer.py /usr/bin/jack_mixer
	dodoc AUTHORS NEWS README
}

pkg_postinst() {
	python_mod_optimize "${EPREFIX}/usr/share/${PN}"
	gnome2_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup "${EPREFIX}/usr/share/${PN}"
	gnome2_pkg_postrm
}
