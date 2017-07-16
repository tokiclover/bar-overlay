# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/zita-ajbridge/zita-ajbridge-0.4.0.ebuild,v 1.0 2014/10/10 Exp $

EAPI=5

inherit base toolchain-funcs

DESCRIPTION="Bridge ALSA devices to Jack clients, to provide additional capture (a2j) or playback (j2a) channels"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/alsa-lib
	>=media-libs/zita-alsa-pcmi-0.2.0
	>=media-libs/zita-resampler-1.3.0
	media-sound/jack-audio-connection-kit[alsa]"

DOCS=( ../{AUTHORS,README} )

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.0-Makefile.patch
)

S="${WORKDIR}/${P}/source"

src_install()
{
	mkdir -p "${ED}"/usr/{bin,share/man/man1}
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
	dodoc "${DOCS[@]}"
}

