# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: app-arch/lz4/lz4-9999.ebuild,v 1.10 2014/07/28 12:58:22 -tclover Exp $

EAPI=5

inherit cmake-utils multilib subversion

CMAKE_USE_DIR="${S}/cmake_unofficial"

ESVN_REPO_URI="http://lz4.googlecode.com/svn/trunk/"
ESVN_PROJECT="lz4"

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://code.google.com/p/lz4/"

LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	subversion_src_prepare
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(-DBUILD_LIBS=ON -DBUILD_SHARED_LIBS=ON)
	cmake-utils_src_configure
}

src_install() {
	if [[ $(get_libdir) != lib ]]; then
		dodir "/usr/$(get_libdir)"
		dosym "$(get_libdir)" /usr/lib
	fi

	cmake-utils_src_install

	if [[ $(get_libdir) != lib ]]; then
		rm "${ED}usr/lib" || die
	fi
}
