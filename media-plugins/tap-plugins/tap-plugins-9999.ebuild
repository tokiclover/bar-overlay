# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/tap-plugins/tap-plugins-9999.ebuild,v 0.1 2014/07/07 18:00:11 -tclover Exp $

EAPI=2

inherit git-2

DESCRIPTION="TAP LADSPA plugins: contains DeEsser, Dynamics, Equalizer, Reverb, Stereo Echo, Tremolo"
HOMEPAGE="http://tap-plugins.sf.net"
EGIT_REPO_URI="git://github.com/tomszilagyi/tap-plugins.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

src_compile() {
	emake || die
}

src_install() {
	dodoc README CREDITS
#	dohtml ${S}/doc/*
	insinto /usr/lib/ladspa
	insopts -m0755
	doins *.so
	insinto /usr/share/ladspa/rdf
	insopts -m0644
	doins *.rdf
}
