# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils git-2

DESCRIPTION="Shelf/Launcher module for fast switching applications for Enlightenment"
HOMEPAGE="https://enlightenment.org"
EGIT_REPO_URI="git://git.enlightenment.org/enlightenment/modules/${PN}.git"

IUSE="+nls static-libs"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD-2"
SLOT="0"

DEPEND="dev-libs/efl"
RDEPEND="${DEPEND}
	>=x11-wm/enlightenment-0.17.0:0.17=
	virtual/libintl"
DEPEND="${DEPEND}
	app-portage/elt-patches"

DOCS=( AUTHORS ChangeLog NEWS README )

AUTOTOOLS_AUTORECONF=1

src_configure()
{
	local -a myeconfargs=(
		${EXTRA_ENGAGE_CONF}
		$(use_enable nls)
	)
	autotools-utils_src_configure
}
