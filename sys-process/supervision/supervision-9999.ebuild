# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-process/supervision/supervision-9999.ebuild,v 1.4 2016/05/08 Exp $

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
	VCS_ECLASS=vcs-snapshot
	SRC_URI="https://github.com/tokiclover/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="Supervision Scripts Framework"
HOMEPAGE="https://github.com/tokiclover/supervision"

LICENSE="BSD-2"
SLOT="0"
IUSE="+runit s6 static-service +sysvinit"

DEPEND="sys-apps/sed
	sysvinit? ( sys-apps/sysvinit )"
RDEPEND="${DEPEND} virtual/daemontools"

src_compile()
{
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)" \
		$(usex sysvinit 'SYSVINIT=1' '')
}
src_install()
{
	sed '/.*COPYING.*$/d' -i Makefile
	local SV=(
		$(usex runit 'RUNIT=1' '')
		$(usex s6    'S6=1'    '')
		$(usex static-service 'STATIC=1' '')
		$(usex sysvinit 'SYSVINIT=1' '')
	)
	emake PREFIX=/usr "${SV[@]}" DESTDIR="${ED}" install-all
}
