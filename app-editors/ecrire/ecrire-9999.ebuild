# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: app-editors/ecrire/ecrire-9999.ebuild,v 1.1 2015/08/12 12:02:10 Exp $

EAPI=5
PLOCALES="ca eo es fr gl he hu it ko lt pl pt sr tr zh_CN"

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://git.enlightenment.org/apps/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		AUTOTOOLS_AUTORECONF=1
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz"
		;;
esac
inherit l10n cmake-utils ${VCS_ECLASS}

DESCRIPTION="EFL simple text editor"
HOMEPAGE="https://enlightenment.org"

IUSE=""
LICENSE="GPL-3"
SLOT="0"

RDEPEND="|| ( >=dev-libs/efl-1.18.0 >=media-libs/elementary-1.8.0 )"
DEPEND="${RDEPEND}
	virtual/libintl"

DOCS=( AUTHORS NEWS README TODO )

src_configure()
{
	local lingus
	linguas="$(l10n_get_locales)"
	echo "${linguas}" > po/LINGUAS

	cmake-utils_src_configure
}
