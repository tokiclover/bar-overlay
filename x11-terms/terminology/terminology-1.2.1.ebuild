# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

case "${PV}" in
	(*9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://git.enlightenment.org/apps/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	AUTOTOOLS_AUTORECONF=1
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
	SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${PN}-${PV/_/-}.tar.xz"
	;;
esac
inherit meson ${VCS_ECLASS}

DESCRIPTION="Feature rich terminal emulator using the Enlightenment Foundation Libraries"
HOMEPAGE="https://www.enlightenment.org/p.php?p=about/terminology"

IUSE="nls"
LICENSE="BSD-2"
SLOT="0"

RDEPEND=">=dev-libs/efl-1.20.0"
DEPEND="${RDEPEND}
	virtual/libintl
	virtual/pkgconfig"

DOCS=(AUTHORS ChangeLog ChangeLog.theme NEWS README.md TODO)

src_configure()
{
	local -a emesonargs=(
		-Dnls=$(usex nls true false)
	)
	meson_src_configure
}
