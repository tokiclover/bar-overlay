# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://gitlab.com/tokiclover/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	VCS_ECLASS=vcs-snapshot
	SRC_URI="https://gitlab.com/tokiclover/${PN}/-/archive/${PV}/${PV}.tar.bz2 -> ${P}.tar.bz2"
	;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="Utility to manage hardware, network, power or other profiles"
HOMEPAGE="https://gitlab.com/tokiclover/hprofile"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/findutils
	sys-apps/diffutils
	sys-apps/sed"

src_install()
{
	sed -e '/.*COPYING.*$/d' -i Makefile
	emake DESTDIR="${ED}" VERSION=${PV} exec_prefix=/ install{,-doc}
}

