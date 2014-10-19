# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-libs/zita-alsa-pcmi-0.2.0ebuild,v 1.0 2014/10/10 -tclover Exp $

EAPI=5

inherit base toolchain-funcs multilib-minimal

DESCRIPTION="Successor of clalsadrv, API providing easy access to ALSA PCM devices"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/alsa-lib[${MULTILIB_USEDEP}]"

DOCS=( AUTHORS README )

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_prepare()
{
	base_src_prepare
	multilib_copy_sources
}

multilib_src_compile()
{
	for dir in libs apps; do
		pushd "${dir}"
		emake
		popd
	done
}

multilib_src_install()
{
	pushd libs
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" PREFIX="${EPREFIX}/usr" install
	popd && pushd apps

	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	popd
}

