# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/vapoursynth-plugins-imagereader/vapoursynth-plugins-imagereader-9999.ebuild,v 1.2 2015/10/01 Exp $

EAPI=5

MY_PN="vsimagereader"
case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/myrsloik/${MY_PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/myrsloik/${MY_PN}/archive/r${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit multilib-minimal ${VCS_ECLASS}

DESCRIPTION="Common set of image-processing filters plugin for VapourSynth"
HOMEPAGE="https://github.com/myrsloik/vsimagereader"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug"

RDEPEND="media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	media-video/vapoursynth:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"


src_prepare()
{
	epatch_user
	sed -e 's/-O[0-3s]//g' -i src/configure
	multilib_copy_sources
}
multilib_src_configure()
{
	pushd src
	chmod +x configure
	./configure \
		${EXTRA_IMAGEREADER_CONF} \
		$(usex debug '--enable-debug' '') \
		--enable-new-png
		--extra-cflags=\"${CXXFLAGS}\" \
		--extra-ldflags=\"${LDFLAGS}\" \
		--install="${EPREFIX}/usr/$(get_libdir)/vapoursynth" \
		--target-os="${CHOST}"
	popd
}
multilib_src_compile()
{
	emake -C src -f GNUmakefile CXX="$(tc-getCXX)" LD="$(tc-getCXX)"
}
multilib_src_install()
{
	exeinto /usr/$(get_libdir)/vapoursynth
	doexe src/libvsimagereader.so*
}
multilib_src_install_all()
{
	dodoc readme.rst
}
