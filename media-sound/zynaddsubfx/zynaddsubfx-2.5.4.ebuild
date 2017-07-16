# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/zynaddsubfx/zynaddsubfx-2.4.4.ebuild,v 1.4 2015/06/08 18:56:16 Exp $

EAPI=5

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=subversion
		EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/code.git"
		EGIT_PROJECT=${PN}.git
		AUTOTOOLS_AUTORECONF=1
		;;
	(*)
		KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
		SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
		;;
esac
inherit eutils cmake-utils ${VCS_ECLASS}

DESCRIPTION="ZynAddSubFX is an opensource software synthesizer."
HOMEPAGE="http://zynaddsubfx.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+alsa +fltk +jack lash oss portaudio"
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

PATCHES=(
	"${FILESDIR}"/${P}-docs.patch
)

DOCS=( ChangeLog HISTORY.txt README.adoc )

src_configure()
{
	append-cxxflags "-std=c++11"
	local -a mycmakeargs=(
		$(use fltk && echo "-DGuiModule=fltk" || echo "-DGuiModule=off")
		$(cmake-utils_use alsa AlsaEnable)
		$(cmake-utils_use jack JackEnable)
		$(cmake-utils_use lash LashEnable)
		$(cmake-utils_use oss OssEnable)
		$(cmake-utils_use portaudio PaEnable)
		-DPluginLibDir=$(get_libdir)
	)
	cmake-utils_src_configure
}

