# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/emotion_generic_players/emotion_generic_players-1.12.0.ebuild,v 1.1 2014/12/01 -tclover Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Provides external applications as generic loaders for Evas"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${PN}-${PV/_/-}.tar.xz"

LICENSE="BSD-2"
SLOT="0/${PV:0:4}"
KEYWORDS="~amd64 ~x86"
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
