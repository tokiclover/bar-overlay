# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-libs/wayland/wayland-9999.ebuild,v 1.1 2013/07/29 09:08:34 -tclover Exp $

EAPI=5

inherit autotools toolchain-funcs git-2

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="http://wayland.freedesktop.org/"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/${PN}/${PN}"
EXPERIMENTAL="true"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc static-libs"

RDEPEND="dev-libs/expat virtual/libffi"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
}

src_configure() {
	myconf="$(use_enable static-libs static) \
			$(use_enable doc documentation)"
	if tc-is-cross-compiler ; then
		myconf+=" --disable-scanner"
	fi
	econf ${myconf}
}

src_test() {
	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	default
}
