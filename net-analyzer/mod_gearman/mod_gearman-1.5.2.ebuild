# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS="" VCS_ECLASS=git-2
	SEC_URI="git://github.com/sni/${PN}.git"
	;;
	(*)
	KEYWORDS="~amd64 x86"
	SRC_URI="http://www.mod-gearman.org/download/v${PV}/src/${P}.tar.gz"
	;;
esac

inherit eutils ${VCS_ECLASS}

DESCRIPTION="Nagios/Icinga distributed active checks and perfdata analyzis (PNP4Nagios) for scalability"
HOMEPAGE="https://labs.consol.de/nagios/mod-gearman/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug perl"

DEPEND="sys-cluster/gearmand
	perl? ( dev-libs/libltdl sys-libs/ncurses:= )"
RDEPEND="${DEPEND}"

src_configure()
{
	econf \
		--with-user="${MONITORING_USER:-nagios}" \
		$(use_enable debug) \
		$(use_enable perl embedded-perl)
}
src_install()
{
	default

	rm -fr "${ED}"/etc/init.d/gearmand "${ED}"/var/lib/log
	mv -f "${ED}"/etc/${PN}/${PN}{_neb,}.conf
	newinitd "${FILESDIR}/${PN}_worker.initd" "${PN}_worker"
	newconfd "${FILESDIR}/${PN}_worker.confd" "${PN}_worker"

	keepdir /var/lib/${PN}
	keepdir /var/log/${PN}
	local user="${MONITORING_USER:-nagios}"
	fowners "${user}:${user}" /var/lib/${PN}
	fperms 775 /var/lib/${PN}
	fowners "${user}:${user}" /var/log/${PN}
	fperms 775 /var/log/${PN}
	insinto /etc/nagios/modules
	doins "${FILESDIR}/${PN}.cfg"
}
