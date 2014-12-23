# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/empc/empc-9999.ebuild,v 1.1 2014/12/12 12:02:10 -tclover Exp $

EAPI=5

PLOCALES="ca eo fr gl it lt pl pt ru sr tr"

inherit l10n autotools-utils git-2

DESCRIPTION="MPD multiplexer/client build on Enlightenment Foundation Libraries"
HOMEPAGE="https://enlightenment.org"
EGIT_REPO_URI="git://git.enlightenment.org/apps/${PN}.git"

IUSE="glyr +id3tag +nls"
LICENSE="BSD-2"
SLOT="0"

RDEPEND=">=dev-libs/efl-1.12:=
	>=media-libs/elementary-1.12:=
	>=media-libs/libmpdclient-2.9
	sys-apps/dbus
	glyr? ( media-libs/glyr )
	id3tag? ( media-libs/libid3tag )"
DEPEND="${RDEPEND}
	virtual/libintl"

DOCS=( AUTHORS README TODO )

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure()
{
	local linguas
	use nls && linguas="$(l10n_get_locales)"
	echo "${linguas}" > po/LINGUAS

	local -a myeconfargs=(
		${EXTRA_EMPC_CONF}
		--disable-mpdule
		$(use_enable glyr module-glyr)
		$(use_enable id3tag module-id3-loader)
	)
	autotools-utils_src_configure
}
