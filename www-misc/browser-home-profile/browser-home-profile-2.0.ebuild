# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: www-misc/browser-home-profile/browser-home-profile-2.0.ebuild,v 1.2 2016/02/24 Exp $

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://github.com/tokiclover/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="Web-Browser Home Profile Utility"
HOMEPAGE="https://github.com/tokiclover/browser-home-profile"

LICENSE="BSD-2"
SLOT="0"
IUSE="perl"

DEPEND="sys-apps/sed"
RDEPEND="${DEPEND}"

src_install()
{
	sed '/.*COPYING.*$/d' -i Makefile
	emake PREFIX=/usr DESTDIR="${ED}" install$(usex perl '-perl' '')
}
