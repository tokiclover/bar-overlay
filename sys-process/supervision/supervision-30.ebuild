# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-process/supervision/supervision-9999.ebuild,v 1.1 2015/03/30 -tclover Exp $

EAPI=5

inherit eutils

DESCRIPTION="Supervision Scripts Framework"
HOMEPAGE="https://github.com/tokiclover/supervision"
SRC_URI="https://github.com/tokiclover/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="daemontools daemontools-encore +runit s6 static-service"

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
		$(usex static-service 'STATIC=1' '')
	)
	emake PREFIX=/usr "${SV[@]}" DESTDIR="${ED}" install-all
}
