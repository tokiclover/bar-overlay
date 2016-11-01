# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-gfx/ephoto/ephoto-9999.ebuild,v 1.2 2015/08/22 12:02:10 Exp $

EAPI=5
PLOCALES="cs de it sk"

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
		SRC_URI="http://www.smhouston.us/stuff/${PN}-${PV/_/-}.tar.gz"
		;;
esac
inherit l10n autotools-utils ${VCS_ECLASS}

DESCRIPTION="EFL image viewer, editor, manipulator and slideshow"
HOMEPAGE="https://enlightenment.org"

IUSE="+nls"
LICENSE="BSD-2"
SLOT="0"

RDEPEND=">=media-libs/elementary-1.8.0"
DEPEND="${RDEPEND}
	nls? ( virtual/libintl )"

DOCS=( AUTHORS NEWS README TODO )

src_configure()
{
	local lingus
	linguas="$(l10n_get_locales)"
	echo "${linguas}" > po/LINGUAS

	local -a myeconfargs=(
		${EXTRA_EPHOTO_CONF}
	)
	autotools-utils_src_configure
}
