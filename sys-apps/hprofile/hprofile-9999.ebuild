# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-apps/hprofile/hprofile-9999.ebuild,v 1.0 2014/09/20 08:41:42 -tclover Exp $

EAPI=5

inherit eutils git-2

DESCRIPTION="Utility to manage hardware, network, power or other profiles"
HOMEPAGE="https://github.com/tokiclover/hprofile"
EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS=""


DEPEND="sys-apps/findutils"
RDEPEND="${DEPEND}
	sys-apps/sed
	app-shell/bash"

DOCS=(AUTHORS BUGS README README.md ChangeLog)

src_install()
{
	emake DESTDIR="${D}" prefix=/usr install
	dodoc "${DOCS[@]}"
}
