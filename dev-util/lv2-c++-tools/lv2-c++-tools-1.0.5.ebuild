# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-util/lv2-c++-tools/lv2-c++-tools-1.0.5.ebuild,v 1.1 2014/10/10 -tclover Exp $

EAPI=5

inherit multilib-minimal toolchain-funcs

DESCRIPTION="some tools and libraries that may come in handy when writing LV2 plugins"
HOMEPAGE="http://ll-plugins.nongnu.org/hacking.html"
SRC_URI="http://download.savannah.nongnu.org/releases/ll-plugins/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-cpp/gtkmm-2.8.8:2.4[${MULTILIB_USEDEP}]
	dev-libs/boost[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog README )

src_prepare()
{
	sed -e 's:ar rcs:$(AR) rcs:' -i Makefile.template || die
	sed -e '/ldconfig/d' -i Makefile.template || die

	multilib_copy_sources
}

multilib_src_compile()
{
	tc-export AR CXX
	emake

	if multilib_is_native_abi && use doc; then
		doxygen || die "Failed to make docs"
	fi
}

multilib_src_install()
{
	emake DESTDIR="${ED}" PREFIX="${EPREFIX}/usr" install

	if multilib_is_native_abi; then
		dodoc "${DOCS[@]}"
		use doc && dohtml -r html/*
	fi
}

