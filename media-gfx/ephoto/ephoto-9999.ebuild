# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-gfx/ephoto/ephoto-9999.ebuild,v 1.1 2014/12/12 12:02:10 -tclover Exp $

EAPI=5

inherit autotools-utils git-2

DESCRIPTION="Image Viewer/Editor/Manipulator/Slideshow creator build on EFL"
HOMEPAGE="https://enlightenment.org"
EGIT_REPO_URI="git://git.enlightenment.org/apps/${PN}.git"

IUSE="quicklaunch"
LICENSE="BSD-2"
SLOT="0"

RDEPEND=">=dev-libs/efl-1.8
	>=media-libs/elementary-1.8[quicklaunch?]"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README TODO )

AUTOTOOLS_AUTORECONF=1

src_configure()
{
	local -a myeconfargs=(
		${EXTRA_EPHOTO_CONF}
		$(use_enable quicklaunch)
	)
	autotools-utils_src_configure
}
