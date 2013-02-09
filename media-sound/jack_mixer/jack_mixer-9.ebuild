# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils gnome2 python

IUSE="lash phat"
RESTRICT="mirror"

DESCRIPTION="JACK audio mixer using GTK2 interface."
HOMEPAGE="http://home.gna.org/jackmixer/"
SRC_URI="http://download.gna.org/jackmixer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Not sure about the required swig version, report if 1.3.25 doesn't work
DEPEND="media-sound/jack-audio-connection-kit
	dev-python/pygtk
	dev-python/fpconst
	>=dev-python/pyxml-0.8.4"
	# 1. only needed for non tarballs aka svn checkouts >=dev-lang/swig-1.3.25
RDEPEND="${DEPEND}
	phat? ( media-libs/pyphat )
	lash? ( || (
		media-sound/ladish[python]
		media-sound/lash[python]
		>=media-libs/pylash-3_pre
		)
	)"

src_prepare() {
	epatch "${FILESDIR}/empty_name_on_rename.patch"
}

src_install() {
	gnome2_src_install
	python_convert_shebangs -r 2 "${ED}"
	dosym /usr/bin/jack_mixer.py /usr/bin/jack_mixer
	dodoc AUTHORS NEWS README
}
