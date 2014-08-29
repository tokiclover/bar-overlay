# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: app-arch/lz4/lz4-9999.ebuild,v 1.11 2014/08/28 12:58:22 -tclover Exp $

EAPI=5

inherit cmake-utils multilib git-2

CMAKE_USE_DIR="${S}/cmake_unofficial"

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://code.google.com/p/lz4/"
EGIT_REPO_URI="git://github.com/Cyan4973/lz4.git"

LICENSE="BSD-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

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
