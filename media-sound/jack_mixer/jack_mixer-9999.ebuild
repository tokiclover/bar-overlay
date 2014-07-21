# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/jack_mixer/jack_mixer-9999.ebuild, 2014/07/15 -tclover $

EAPI="4"

inherit eutils gnome2 python autotools git-2

PYTHON_DEPEND="2"

DESCRIPTION="JACK audio mixer using GTK2 interface."
HOMEPAGE="http://home.gna.org/jackmixer/"
EGIT_REPO_URI="git://repo.or.cz/jack_mixer.git"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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

src_prepare() {
	epatch "${FILESDIR}"/missing-gconf-2.m4.patch
	AT_M4DIR="m4" eautoreconf
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
