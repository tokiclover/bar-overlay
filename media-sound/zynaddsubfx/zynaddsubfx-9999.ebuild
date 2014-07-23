# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/zynaddsubfx/zynaddsubfx-9999.ebuild,v 1.2 2014/07/20 17:56:16 -tclover Exp $

EAPI="5"

inherit eutils cmake-utils git-2

DESCRIPTION="ZynAddSubFX is an opensource software synthesizer."
HOMEPAGE="http://zynaddsubfx.sourceforge.net/"
EGIT_REPO_URI="git://git.code.sf.net/p/zynaddsubfx/code.git"
EGIT_PROJECT=${PN}.git

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+alsa +fltk +jack +lash oss portaudio"
REQUIRED_USE="lash? ( alsa ) !alsa? ( jack )"

RDEPEND=">=dev-libs/mini-xml-2.2.1
	sci-libs/fftw:3.0
	alsa? ( media-libs/alsa-lib )
	fltk? ( >=x11-libs/fltk-1.1:1 )
	jack? ( media-sound/jack-audio-connection-kit )
	lash? ( virtual/liblash )
	oss? ( media-sound/oss )
	portaudio? ( >=media-libs/portaudio-19_pre )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="ChangeLog FAQ.txt HISTORY.txt README.txt bugs.txt"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.1-docs.patch
)

src_configure() {
	local mycmakeargs=(
		$(use fltk && echo "-DGuiModule=fltk" || echo "-DGuiModule=off")
		$(cmake-utils_use alsa AlsaEnable)
		$(cmake-utils_use jack JackEnable)
		$(cmake-utils_use lash LashEnable)
		$(cmake-utils_use oss OssEnable)
		$(cmake-utils_use portaudio PaEnable)
	)
	cmake-utils_src_configure
}
