# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-video/vapoursynth-plugins-filters/vapoursynth-plugins-filters-9999.ebuild,v 1.1 2015/09/24 Exp $

EAPI=5

MY_PN="GenericFilters"
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
inherit eutils ${VCS_ECLASS}

DESCRIPTION="Common set of image-processing filters plugin for VapourSynth"
HOMEPAGE="https://github.com/myrsloik/GenericFilters"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug"

RDEPEND="media-video/vapoursynth:="
DEPEND="${RDEPEND}"

DOCS=( readme.rst )

src_prepare()
{
	epatch_user
}
src_configure()
{
	src/configure \
		${EXTRA_FILTERS_CONF} \
		$(usex debug '--enable-debug' '') \
		--extra-cflags="${CXXFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		--install="${EPREFIX}/usr/$(get_libdir)/vapoursynth" \
		--target-os="${CHOST}"
}
src_compile()
{
	emake -f src/GNUmakefile
}
src_install()
{
	emake -f src/GNUmakefile libdir="${ED}/usr/$(get_libdir)/vapoursynth" install
	dodoc "${DOCS[@]}"
}
