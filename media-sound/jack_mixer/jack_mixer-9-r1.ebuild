# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.4"
RESTRICT_PYTHON_ABIS="3.*"
inherit eutils gnome2 python

DESCRIPTION="JACK audio mixer using GTK2 interface."
HOMEPAGE="http://home.gna.org/jackmixer/"
SRC_URI="http://download.gna.org/jackmixer/${P}.tar.gz"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gconf lash phat"

DEPEND="dev-python/fpconst
	dev-python/pygtk
	>=dev-python/pyxml-0.8.4
	media-sound/jack-audio-connection-kit"
RDEPEND="${DEPEND}
	gconf? ( dev-python/gconf-python:2 )
	lash? (	|| (
		media-sound/ladish[python]
		media-sound/lash[python]
		>=media-libs/pylash-3_pre
		)
	)
	phat? ( media-libs/pyphat )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/empty_name_on_rename.patch"
	gnome2_src_prepare
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
