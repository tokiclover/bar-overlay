# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-util/eflete/eflete-9999.ebuild,v 1.1 2015/02/02 12:02:10 -tclover Exp $

EAPI=5

inherit autotools-utils git-2

DESCRIPTION="EFL Edje Theme Editor - a theme graphical editor"
HOMEPAGE="https://enlightenment.org"
EGIT_REPO_URI="git://git.enlightenment.org/devs/rimmed/${PN}.git"

IUSE="debug doc"
LICENSE="BSD-2"
SLOT="0"

EFL_VERSION=1.12.99
RDEPEND=">=dev-libs/efl-${EFL_VERSION}
	>=media-libs/elementary-${EFL_VERSION}
	>=dev-util/enventor-0.4.0
	>=media-libs/ewe-0.2.2"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/libintl"

DOCS=( AUTHORS ChangeLog NEWS NOTES README )

AUTOTOOLS_AUTORECONF=1

src_configure()
{
	local -a myeconfargs=(
		${EXTRA_EFLETE_CONF}
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
