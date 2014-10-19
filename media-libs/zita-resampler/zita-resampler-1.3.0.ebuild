# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-libs/zita-resampler-1.3.0.ebuild,v 1.0 2014/10/10 -tclover Exp $

EAPI=5

inherit base toolchain-funcs multilib

DESCRIPTION="C++ library for real-time resampling of audio signals"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+doc"

DEPEND="media-libs/libsndfile"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

DOCS=( AUTHORS README )

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_compile()
{
	for dir in libs apps; do
		pushd "${dir}"
		emake PREFIX="${EPREFIX}"/usr
		popd
	done
}

src_install()
{
	pushd libs
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR=$(get_libdir) install
	popd && pushd apps
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	popd

	dodoc "${DOCS[@]}"
	use doc && dohtml -r docs
}

