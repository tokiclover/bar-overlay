# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-libs/wayland/wayland-9999.ebuild,v 1.4 2015/06/06 09:08:34 -tclover Exp $

EAPI=5

case "${PV}" in
	(*9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/${PN}/${PN}"
	EGIT_PROJECT="${PN}.git"
	case "${PV}" in
		(*.9999*) EGIT_BRANCH="${PV:0:3}";;
	esac
	AUTOTOOLS_AUTORECONF=1
	;;
	(*)
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	SRC_URI="http://wayland.freedesktop.org/releases/${P}.tar.xz"
	;;
esac
inherit autotools-multilib toolchain-funcs ${VCS_ECLASS}

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="http://wayland.freedesktop.org/"

LICENSE="MIT"
SLOT="0/${PV:0:3}"
IUSE="doc static-libs"

RDEPEND=">=dev-libs/expat-2.1.0-r3:=[${MULTILIB_USEDEP}]
	>=virtual/libffi-3.0.13-r1:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

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

