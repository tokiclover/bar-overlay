# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-process/supervision-scripts/supervision-scripts-9999.ebuild,v 1.1 2015/02/22 -tclover Exp $

EAPI=5

inherit eutils git-2

DESCRIPTION="Supervision Scripts Framework"
HOMEPAGE="https://github.com/tokiclover/supervision-scripts"
EGIT_REPO_URI="git://github.com/tokiclover/supervision-scripts.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="daemontools daemontools-encore +runit s6"

DEPEND="sys-apps/sed"
RDEPEND="${DEPEND}
	daemontools? ( sys-process/daemontools )
	daemontools-encore? ( sys-process/daemontools-encore )
	runit? ( sys-process/runit )
	s6? ( sys-apps/s6 )"

src_install()
{
	local SV=(
		$(usex runit 'RUNIT=1' '')
		$(usex s6    'S6=1'    '')
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
