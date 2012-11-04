# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/dev-libs/wayland/wayland-9999.ebuild,v 1.0 2012/11/04 15:30:05 -tclover Exp $

EAPI=4

inherit autotools toolchain-funcs git-2

DESCRIPTION="Wayland protocol libraries"
HOMEPAGE="http://wayland.freedesktop.org/"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/${PN}/${PN}"

EXPERIMENTAL="true"

LICENSE="CCPL-Attribution-ShareAlike-3.0 MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +wayland-scanner static-libs"

RDEPEND="dev-libs/expat dev-libs/libffi"
DEPEND="${RDEPEND} doc? ( app-doc/doxygen )"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc documentation) \
		$(use_enable wayland-scanner scanner) \
		$(use_enable static-libs static)
}
