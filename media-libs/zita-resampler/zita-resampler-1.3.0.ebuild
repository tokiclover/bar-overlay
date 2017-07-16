# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-libs/zita-resampler-1.3.0.ebuild,v 1.0 2014/10/10 Exp $

EAPI=5

inherit base toolchain-funcs multilib-minimal

DESCRIPTION="C++ library for real-time resampling of audio signals"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+doc"

DEPEND="media-libs/libsndfile[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

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
	local -a DIRS=(libs)
	multilib_is_native_abi && DIRS+=(apps)

	for dir in "${DIRS[@]}"; do
		pushd "${dir}"
		emake PREFIX="${EPREFIX}"/usr
		popd
	done
}

multilib_src_install()
{
	local -a DIRS=(libs)
	multilib_is_native_abi && DIRS+=(apps)

	for dir in "${DIRS[@]}"; do
		pushd "${dir}"
		emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" \
			LIBDIR=$(get_libdir) install
		popd
	done
}

multilib_src_install_all()
{
	dodoc "${DOCS[@]}"
	use doc && dohtml -r docs
}

