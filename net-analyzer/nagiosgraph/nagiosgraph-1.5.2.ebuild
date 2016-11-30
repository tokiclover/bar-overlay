# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-app

DESCRIPTION="Graph plugin for Nagios using RRDtool"
HOMEPAGE="http://nagiosgraph.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl
	|| ( virtual/httpd-cgi virtual/httpd-fastcgi )
	net-analyzer/rrdtool[perl]"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS CHANGELOG README README.html TODO )

src_install()
{
	sed 's,Nagios::Config,Nagios::Plugin::Config,g' -i cgi/showconfig.cgi \
		etc/ngshared.pm

	DESTDIR="${ED}" NG_WWW_USER=apache NG_APACHE_CONFIG_DIR=/etc/apache2/modules.d \
		./install.pl --layout redhat --doc-dir /usr/share/doc/${P} \
		--nagios-perfdata-file /var/nagios/service-perfdata.log

	local dir
	for dir in /var/spool/nagiosgraph /var/spool/nagiosgraph/rrd; do
		keepdir ${dir}
		fowners nagios:nagios ${dir}
	done
	fperms 775 /var/log/nagiosgraph
	fowners apache:nagios /var/log/nagiosgraph

	dodir /etc/apache2/modules.d /etc/logrotate.d /etc/nagios/objects
	cp "${FILESDIR}"/99_nagiosgraph.conf "${ED}"/etc/apache2/modules.d
	cp "${FILESDIR}"/nagiosgraph.cfg "${ED}"/etc/nagios/objects
	cp examples/nagiosgraph-logrotate "${ED}"/etc/logrotate.d/nagiosgraph
	rm -f "${ED}"/etc/${PN}/${PN}{-,_}*.conf \
		"${ED}"/etc/${PN}/${PN}-commands.cfg \
		"${ED}"/etc/${PN}/${PN}-nagios.cfg

	dodoc "${DOCS[@]}"
}
pkg_postinst()
{
	elog "---"
	elog "Don't forget to add '-D NAGIOSGRAPH' to apache configuration file;"
	elog "and then review /etc/apache2/modules.d/99_nagiosgraph.conf and"
	elog "modify it to get nagiosgraph to be functional."
	elog
	elog "And do not forget to add the following lines to /etc/nagios/nagios.cfg:"
	elog
	elog "cfg_file=/etc/nagios/objects/nagiosgraph.cfg"
	elog "service_perfdata_file=/var/nagios/service-perfdata.log"
	elog "service_perfdata_file_template=$LASTSERVICECHECK$||$HOSTNAME$||$SERVICEDESC$||$SERVICEOUTPUT$||$SERVICEPERFDATA$"
	elog "service_perfdata_file_mode=a"
	elog "service_perfdata_file_processing_interval=30"
	elog "service_perfdata_file_processing_command=process-service-perfdata-nagiosgraph"
	elog
	elog "after process_performance_data=1 line (which should be enabled!)"
	elog "---"
}
