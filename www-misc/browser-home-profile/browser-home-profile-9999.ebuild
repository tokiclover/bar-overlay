# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: www-misc/browser-home-profile/browser-home-profile-9999.ebuild,v 1.2 2015/05/14 Exp $

EAPI=5

inherit eutils git-2

DESCRIPTION="Web-Browser Home Profile Utility"
HOMEPAGE="https://github.com/tokiclover/browser-home-profile"
EGIT_REPO_URI="git://github.com/tokiclover/browser-home-profile.git"

LICENSE="BSD-2"
SLOT="0"

DEPEND="sys-apps/sed"
RDEPEND="${DEPEND}"

src_install()
{
	sed '/.*COPYING.*$/d' -i Makefile
	emake PREFIX=/usr DESTDIR="${ED}" install
}
