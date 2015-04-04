# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-process/supervision/supervision-9999.ebuild,v 1.2 2015/03/30 -tclover Exp $

EAPI=5

inherit eutils git-2

DESCRIPTION="Supervision Scripts Framework"
HOMEPAGE="https://github.com/tokiclover/supervision"
EGIT_REPO_URI="git://github.com/tokiclover/supervision-scripts.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="+runit s6 static-service"

DEPEND="sys-apps/sed"
RDEPEND="${DEPEND} virtual/daemontools"

src_install()
{
	local SV=(
		$(usex runit 'RUNIT=1' '')
		$(usex s6    'S6=1'    '')
		$(usex static-service 'STATIC=1' '')
	)
	emake PREFIX=/usr "${SV[@]}" DESTDIR="${ED}" install-all
}

pkg_postinst()
{
	elog "Do not forget to run \`sv/.bin/supervision-backend BACKEND'!"
}

pkg_postinst()
{
	elog "Do not forget to run \`sv/.bin/supervision-backend BACKEND'!"
}
