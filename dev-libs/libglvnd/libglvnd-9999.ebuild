# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-libs/libglvnd/libglvnd-9999.ebuild,v 1.0 2016/06/04 12:58:22 Exp $

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://github.com/NVIDIA/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	AUTOTOOLS_AUTORECONF=1
	;;
	(*)
	KEYWORDS="~amd64"
	VCS_ECLASS=vcs-snapshot
	SRC_URI="https://github.com/NVIDIA/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	;;
esac
inherit autotools-multilib toolchain-funcs ${VCS_ECLASS}

DESCRIPTION="The GL Vendor-Neutral Dispatch library"
HOMEPAGE="https://github.com/NVIDIA/libglvnd"

LICENSE="MIT MIT-with-advertising"
SLOT="0/0.1"
IUSE="+nptl"

DEPEND="dev-libs/uthash
	x11-libs/libX11:=[${MULTILIB_USEDEP}]
	x11-libs/libXext:=[${MULTILIB_USEDEP}]
	x11-proto/glproto[${MULTILIB_USEDEP}]
"

DOCS=( README.md )

src_prepare()
{
	autotools-utils_src_prepare
	multilib_copy_sources
}
multilib_src_configure()
{
	local -a myeconfargs=( ${EXTRA_LIBGLVND_CONF} )
	myeconfargs+=(
		$(use_enable nptl tls)
	)
	autotools-utils_src_configure
}
