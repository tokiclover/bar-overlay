# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-apps/hprofile/hprofile-9999.ebuild,v 1.3 2014/11/01 08:41:42 -tclover Exp $

EAPI=5

inherit eutils git-2

DESCRIPTION="Utility to manage hardware, network, power or other profiles"
HOMEPAGE="https://github.com/tokiclover/hprofile"
EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"

LICENSE="GPL-2"
SLOT="0/${PV:0:1}"
KEYWORDS=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/findutils
	sys-apps/diffutils
	sys-apps/sed
	app-shells/zsh"

src_install()
{
	sed -e '/.*COPYING.*$/d' -i Makefile
	emake DESTDIR="${ED}" prefix=${EPREFIX}/ \
		docdir=${EPREFIX}/usr/share/doc/${P} install{,-doc}
}

