# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/jack_mixer/jack_mixer-10.ebuild, 2014/09/15 $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2 python-single-r1 git-2

DESCRIPTION="JACK audio mixer using GTK2 interface."
HOMEPAGE="http://home.gna.org/jackmixer/"
EGIT_REPO_URI="git://repo.or.cz/jack_mixer.git"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="gconf lash phat"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=">=media-sound/jack-audio-connection-kit-0.102.0
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/fpconst[${PYTHON_USEDEP}]
	>=dev-python/pyxml-0.8.4[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}
	phat? ( media-libs/pyphat[${PYTHON_USEDEP}] )
	gconf? ( dev-python/gconf-python:2[${PYTHON_USEDEP}] )
	lash? ( virtual/liblash[python] )"

DOCS=( AUTHORS NEWS README )

PATCHES=(
	"${FILESDIR}"/missing-gconf-2.m4.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
	AT_M4DIR="m4" eautoreconf
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	python_convert_shebangs -r 2 "${ED}"
	dosym /usr/bin/jack_mixer.py /usr/bin/jack_mixer
}

pkg_postinst() {
	python_mod_optimize "${EPREFIX}/usr/share/${PN}"
	gnome2_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup "${EPREFIX}/usr/share/${PN}"
	gnome2_pkg_postrm
}
