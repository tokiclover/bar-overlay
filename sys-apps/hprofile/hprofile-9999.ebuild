# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-apps/hprofile/hprofile-9999.ebuild,v 1.4 2015/05/01 08:41:42 -tclover Exp $

EAPI=5

inherit eutils git-2

DESCRIPTION="Utility to manage hardware, network, power or other profiles"
HOMEPAGE="https://github.com/tokiclover/hprofile"
EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

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

