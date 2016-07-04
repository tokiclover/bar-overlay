# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-process/supervision/supervision-9999.ebuild,v 1.5 2016/06/08 Exp $

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

src_configure()
{
	econf ${EXTRA_CONF_SUPERVISION} \
		$(use_enable runit) \
		$(use_enable s6) \
		$(use_enable static-service) \
		$(use_enable sysvinit)
}
src_compile()
{
	emake
}
src_install()
{
	sed '/.*COPYING.*$/d' -i Makefile
	emake DESTDIR="${D}" install-all
}
