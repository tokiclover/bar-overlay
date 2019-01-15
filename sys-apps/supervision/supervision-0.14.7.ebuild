# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://gitlab.com/tokiclover/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	VCS_ECLASS=vcs-snapshot
	SRC_URI="https://gitlab.com/tokiclover/${PN}/-/archive/${PV}/${PV}.tar.bz2 -> ${P}.tar.bz2"
	;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="Supervision init-system and service-manager"
HOMEPAGE="https://gitlab.com/tokiclover/supervision"

LICENSE="BSD-2"
SLOT="0"
IUSE="debug +runit s6 sysvinit"

DEPEND="sys-apps/grep
	sys-apps/sed
	sys-process/procps
	sysvinit? ( sys-apps/sysvinit )"
RDEPEND="${DEPEND}
	virtual/daemontools"

src_configure()
{
	econf ${EXTRA_CONF_SUPERVISION} \
		--libdir="/$(get_libdir)" \
		$(use_enable debug) \
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
	emake DESTDIR="${D}" install
	keepdir $(get_libdir)/sv/cache

	if use prefix; then
		sed -e "s|^#\(SV_SYSTEM=\).*$|\1=\"prefix\"|" \
			-e "s|^#\(SV_PREFIX=\).*$|\1=\"${EPREFIX}\"|" \
			-i ${D}/etc/sv.conf

		local level
		for level in sysinit sysboot single default shutdown; do
			dodir /usr/share/${PN}/sv.init.d/${level}
			cp -a ${D}/etc/sv.init.d/${level}/* ${D}/usr/share/${PN}/sv.init.d/${level}
			rm ${D}/etc/sv.init.d/${level}/*
		done
	fi
}
pkg_postinst()
{
	elog "If CONFIG_RTC_HCTOSYS is set in the kernel;"
	elog "Remove hwclock service from sysboot runlevel:"
	elog "\`sv-run --sysboot hwclock del'"
	elog
	elog "Updating the previous installation (if any)..."
	/lib/sv/sbin/sv-config --update
}
