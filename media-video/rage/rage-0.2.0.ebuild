# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-video/rage/rage-9999.ebuild,v 1.1 2015/05/28 12:02:10 Exp $

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

DESCRIPTION="EFL Video Player"
HOMEPAGE="https://enlightenment.org"

IUSE=""
LICENSE="BSD-2"
SLOT="0"

RDEPEND=">=dev-libs/efl-1.18.0"
DEPEND="${RDEPEND}
	app-portage/elt-patches"

DOCS=( AUTHORS README TODO )
