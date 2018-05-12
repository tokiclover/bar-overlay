# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

DESCRIPTION="Supervision init-system and service-manager"
HOMEPAGE="https://github.com/tokiclover/supervision"

LICENSE="BSD-2"
SLOT="0"
IUSE="+runit s6 sysvinit"

DEPEND="sys-apps/grep
	sys-apps/sed
	sys-process/procps
	sysvinit? ( sys-apps/sysvinit )"
RDEPEND="${DEPEND} virtual/daemontools"

src_configure()
{
	econf ${EXTRA_CONF_SUPERVISION} \
		--libdir="/$(get_libdir)" \
		$(use_enable runit) \
		$(use_enable s6) \
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
	keepdir $(get_libdir)/sv/cache
}
