# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/zynaddsubfx/zynaddsubfx-2.4.4.ebuild,v 1.1 2014/07/07 18:56:16 -tclover Exp $

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="ZynAddSubFX is an opensource software synthesizer."
HOMEPAGE="http://zynaddsubfx.sourceforge.net/"
SRC_URI="mirror://sourceforge/zynaddsubfx/${PN}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+alsa +fltk +jack lash oss portaudio"
REQUIRED_USE="lash? ( alsa ) !alsa? ( jack )"

RDEPEND=">=dev-libs/mini-xml-2.2.1
	sci-libs/fftw:3.0
	alsa? ( media-libs/alsa-lib )
	fltk? ( >=x11-libs/fltk-1.1:1 )
	jack? ( media-sound/jack-audio-connection-kit )
	lash? ( || ( media-sound/ladish media-sound/lash ) )
	oss? ( media-sound/oss )
	portaudio? ( >=media-libs/portaudio-19_pre )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.1-docs.patch
)

DOCS="ChangeLog FAQ.txt HISTORY.txt README.txt bugs.txt"

src_configure() {
	local mycmakeargs=(
		$(use fltk && echo "-DGuiModule=fltk" || echo "-DGuiModule=off")
		$(use alsa && echo "-DAlsaEnable=true" || echo "-DAlsaEnable=false")
		$(use jack && echo "-DJackEnable=true" || echo "-DJackEnable=false")
		$(use lash && echo "-DLashEnable=true" || echo "-DLashEnable=false")
		$(use oss && echo "-DOssEnable=true" || echo "-DOssEnable=false")
		$(use portaudio && echo "-DPaEnable=true" || echo "-DPaEnable=true")
	)
	cmake-utils_src_configure
}
