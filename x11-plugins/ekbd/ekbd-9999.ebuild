# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: x11-plugins/ekbd/ekbd-9999.ebuild,v 1.4 2014/12/22 12:02:10 Exp $

EAPI=5

inherit autotools-utils git-2

DESCRIPTION="A smart vkbd(virtual keyboard) library inspired by illume-keyboard."
HOMEPAGE="https://enlightenment.org"
EGIT_REPO_URI="git://git.enlightenment.org/libs/${PN}.git"

IUSE="+X"
KEYWORDS=""
LICENSE="BSD-2"
SLOT="0"

RDEPEND=">=dev-libs/efl-1.8.0[X?]
	>=media-libs/elementary-1.8.0[X?]"
DEPEND="${DEPEND}
	virtual/libintl"

DOCS=( AUTHORS ChangeLog README )

AUTOTOOLS_AUTORECONF=1

src_configure()
{
	local -a myeconfargs=(
		$(usex X '' '--disable-x11')
	)
	autotools-utils_src_configure
}
