# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-gfx/ephoto/ephoto-9999.ebuild,v 1.2 2015/05/22 12:02:10 -tclover Exp $

EAPI=5

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://git.enlightenment.org/apps/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		AUTOTOOLS_AUTORECONF=1
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${PN}-${PV/_/-}.tar.xz"
		;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="EFL (Enlightenment Foundation Libraries) image viewer, editor, manipulator and slideshow"
HOMEPAGE="https://enlightenment.org"

IUSE="quicklaunch"
LICENSE="BSD-2"
SLOT="0"

RDEPEND=">=dev-libs/efl-1.8
	>=media-libs/elementary-1.8[quicklaunch?]"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README TODO )

src_configure()
{
	local -a myeconfargs=(
		${EXTRA_EPHOTO_CONF}
		$(use_enable quicklaunch)
	)
	autotools-utils_src_configure
}
