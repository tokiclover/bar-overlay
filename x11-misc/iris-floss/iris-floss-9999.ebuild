# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://github.com/danielng01/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	VCS_ECLASS=vcs-snapshot
	SRC_URI="https://github.com/danielng01/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="Screen color temperature management software"
HOMEPAGE="http://iristech.co"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-base/xorg-server
	x11-libs/libX11
	x11-libs/libXrandr"
RDEPEND="${DEPEND}"

src_install()
{
	dodoc README.md
	dobin iris-floss
}
