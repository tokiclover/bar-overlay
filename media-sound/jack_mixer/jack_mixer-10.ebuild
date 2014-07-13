# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/jack_mixer/jack_mixer-10.ebuild, 2014/07/14 -tclover $

EAPI=4

inherit eutils gnome2 python

IUSE="lash phat"

DESCRIPTION="JACK audio mixer using GTK2 interface."
HOMEPAGE="http://home.gna.org/jackmixer/"
SRC_URI="mirror://download.gna.org/jackmixer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-sound/jack-audio-connection-kit-0.102.0
	dev-python/pygtk
	dev-python/fpconst
	>=dev-python/pyxml-0.8.4"

RDEPEND="${DEPEND}
	phat? ( media-libs/pyphat )
	lash? ( || (
		media-sound/ladish[python]
		media-sound/lash[python]
		>=media-libs/pylash-3_pre
		)
	)"

src_install() {
	gnome2_src_install
	python_convert_shebangs -r 2 "${ED}"
	dosym /usr/bin/jack_mixer.py /usr/bin/jack_mixer
	dodoc AUTHORS NEWS README
}
