# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/emotion_generic_players/emotion_generic_players-1.12.0.ebuild,v 1.2 2015/05/26 Exp $

EAPI=5

case "${PV}" in
	(*9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://git.enlightenment.org/core/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	case "${PV}" in
		(*.9999*) EGIT_BRANCH="${PN}-${PV:0:4}";;
	esac
	AUTOTOOLS_AUTORECONF=1
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://download.enlightenment.org/rel/libs/${PN}/${PN}-${PV/_/-}.tar.xz"
	;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="Provides external applications as generic loaders for Evas"
HOMEPAGE="http://www.enlightenment.org/"

LICENSE="BSD-2"
SLOT="0/${PV:0:4}"
IUSE="debug +vlc"

RDEPEND="
	>=dev-libs/efl-1.8.0
	vlc? ( >=media-video/vlc-2.0 )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

DOCS=( AUTHORS ChangeLog README NEWS )

S="${WORKDIR}/${PN}-${PV/_/-}"

src_configure()
{
	local -a myeconfargs=(
		${EXTRA_EGP_CONF}
		--with-profile=$(usex debug debug release)
		$(use_with vlc)
	)
	autotools-utils_src_configure
}
