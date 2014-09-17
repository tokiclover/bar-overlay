# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-plugins/ekbd/ekbd-9999.ebuild,v 1.3 2014/09/16 12:02:10 -tclover Exp $

EAPI=5

inherit autotools-utils git-2

DESCRIPTION="A smart vkbd(virtual keyboard) library inspired by illume-keyboard."
HOMEPAGE="https://enlightenment.org"
EGIT_REPO_URI="git://git.enlightenment.org/libs/${PN}.git"

IUSE="+X"
KEYWORDS=""
LICENSE="BSD-2"
SLOT="0"

DEPEND="virtual/libintl
	>=dev-libs/efl-1.8.0[X?]
	>=media-libs/elementary-1.8.0[X?]"
RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myeconfargs=(
		$(use X || echo "--disable-x11")
	)
	autotools-utils_src_configure
}
