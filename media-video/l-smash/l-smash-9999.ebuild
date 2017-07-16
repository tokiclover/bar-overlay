# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-video/l-smash/l-smash-9999.ebuild,v 1.2 2016/05/12 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/${PN}/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit multilib-minimal ${VCS_ECLASS}

DESCRIPTION="(FFmpeg) Libavcodec-SMASH decoder/demuxer wrapper library"
HOMEPAGE="https://github.com/l-smash/l-smash"

LICENSE="ISC"
SLOT="0/2"
IUSE="debug static-libs"

RDEPEND=">=media-video/ffmpeg-2.4.0:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare()
{
	epatch_user
	sed -e 's/-O[s0]//g' -i configure
	multilib_copy_sources
}
multilib_src_configure()
{
	chmod +x configure
	local myeconfargs=(
		${EXTRA_LSMASH_CONF}
		$(usex debug '--enable-debug' '')
		$(usex static-libs '' '--disable-static --enable-shared')
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		--destdir="${ED}"
		--includedir=/usr/include
		--cc="$(tc-getCC)"
		--extra-cflags="${CFLAGS}"
		--extra-ldflags="${LDFLAGS}"
		--target-os="${CHOST}"
	)
	echo configure "${myeconfargs[@]}"
	./configure "${myeconfargs[@]}"
}
