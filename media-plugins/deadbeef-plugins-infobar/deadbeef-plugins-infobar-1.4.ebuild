# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://bitbucket.org/dsimbiriatin/deadbeef-infobar.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~x86"
		VCS_ECLASS=vcs-snapshot
		SRC_URI="https://bitbucket.org/dsimbiriatin/${PN/-plugins}/downloads/${P/-plugins}.tar.gz"
		;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="Info-bar plugin for DeaDBeeF audio player"
HOMEPAGE="https://bitbucket.org/dsimbiriatin/deadbeef-infobar/wiki/Home"

LICENSE="GPL-2"
SLOT="0"
IUSE="gtk gtk3"
REQUIRED_USE="|| ( gtk gtk3 )"

DEPEND="dev-libs/libxml2"
RDEPEND=">=media-sound/deadbeef-0.6.0[curl,gtk?,gtk3?]
	${DEPEND}"

src_compile()
{
	use gtk && emake gtk2
	use gtk3 && emake gtk3
}

src_install()
{
	EXEOPTIONS="-m0755"
	exeinto /usr/$(get_libdir)/deadbeef
	doexe gtk*/ddb_infobar_gtk*.so
}
