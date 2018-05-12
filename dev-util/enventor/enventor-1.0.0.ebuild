# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="ru"

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
inherit l10n autotools-utils ${VCS_ECLASS}

DESCRIPTION="EFL Dynamic EDC editor"
HOMEPAGE="https://enlightenment.org"

IUSE=""
LICENSE="BSD-2"
SLOT="0"

RDEPEND="|| ( >=dev-libs/efl-1.18.0 >=media-libs/elementary-1.16.0 )"
DEPEND="${RDEPEND}
	app-portage/elt-patches
	virtual/libintl"

DOCS=( AUTHORS NEWS README )

src_prepare()
{
	sed -re 's,(--g[ch]),--eo \1,g' -i Makefile_Eolian_Helper.am
	autotools-utils_src_prepare
}
