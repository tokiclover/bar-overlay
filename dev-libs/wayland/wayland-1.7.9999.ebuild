# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-libs/wayland/wayland-1.6.9999.ebuild,v 1.3 2015/02/10 09:08:34 -tclover Exp $

EAPI=5

inherit autotools-multilib toolchain-funcs git-2

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="http://wayland.freedesktop.org/"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/${PN}/${PN}"
EGIT_PROJECT="${PN}.git"
EGIT_BRANCH=${PV:0:3}

LICENSE="MIT"
SLOT="0/${PV:0:3}"
IUSE="doc static-libs"

RDEPEND=">=dev-libs/expat-2.1.0-r3:=[${MULTILIB_USEDEP}]
	>=virtual/libffi-3.0.13-r1:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

AUTOTOOLS_AUTORECONF=1

multilib_src_configure()
{
	local -a myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable doc documentation)
	)
	if tc-is-cross-compiler; then
		myeconfargs+=( --disable-scanner )
	fi
	if ! multilib_is_native_abi; then
		myeconfargs+=( --disable-documentation )
	fi
	autotools-multilib_src_configure
}

multilib_src_test()
{
	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	autotools-multilib_src_test
}

