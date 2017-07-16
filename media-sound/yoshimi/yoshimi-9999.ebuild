# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/yoshimi/yoshimi-1.2.4.ebuild,v 1.2 2015/06/08 Exp $

EAPI=5

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=subversion
		ESVN_REPO_URI="git://git.code.sf.net/p/${PN}/code.git"
		ESVN_PROJECT=${PN}.git
		AUTOTOOLS_AUTORECONF=1
		;;
	(*)
		KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
		SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
		;;
esac
inherit cmake-utils ${VCS_ECLASS}

DESCRIPTION="A software synthesizer for Linux, based on ZynAddSubFX"
HOMEPAGE="http://yoshimi.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="dev-libs/boost
	>=dev-libs/mini-xml-2.5
	>=media-libs/alsa-lib-1.0.17
	>=media-libs/fontconfig-0.22
	media-libs/libsndfile
	>=media-sound/jack-audio-connection-kit-0.115.6
	sci-libs/fftw:3.0
	sys-libs/zlib
	x11-libs/cairo
	>=x11-libs/fltk-1.1.2:1[opengl]"
RDEPEND="${DEPEND}"

DOCS=( ../Changelog )

S="${WORKDIR}/${P}/src"

src_prepare()
{
	sed -e 's/-O3 -march=.*-m64/-m64/g' -i CMakeLists.txt
	cmake-utils_src_prepare
}

src_install()
{
	cmake-utils_src_install
	newicon {../desktop/,}${PN}.svg
	rm -f -r "${ED}"/usr/share/icons
}

pkg_postinst()
{
	einfo "Banks are installed into"
	einfo "${EPREFIX}/usr/share/${PN}/banks"
	einfo "Set above dir in Yoshimi > Settings > Bank root dir"
}

