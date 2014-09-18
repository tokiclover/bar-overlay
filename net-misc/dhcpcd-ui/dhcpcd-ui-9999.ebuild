# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-misc/dhcpcd-ui/dhcpcd-ui-0.7.2.ebuild,v 1.1 2014/09/18 18:29:24 -tclover Exp $

EAPI=5

if [[ ${PV} == "9999" ]]; then
	FOSSIL_URI="http://roy.marples.name/projects/dhcpcd"
else
	SRC_URI="http://roy.marples.name/downloads/${PN}/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
fi

inherit eutils systemd

DESCRIPTION="Desktop notification and configuration for dhcpcd"
HOMEPAGE="http://roy.marples.name/projects/dhcpcd-ui/"

LICENSE="BSD-2"
SLOT="0"
IUSE="debug gtk gtk3 icons qt4 systemd libnotify"
REQUIRED_USE="qt4? ( icons )"

DEPEND="virtual/libintl
	libnotify? ( virtual/notification-daemon )
	gtk?  ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	qt4?  ( dev-qt/qtgui )"

RDEPEND="${DEPEND}
	!icons? ( x11-themes/hicolor-icon-theme )"

if [[ ${PV} == "9999" ]]; then
	DEPEND+=" dev-vcs/fossil"

	src_unpack()
	{
		local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
		local repo=${distdir}/fossil/${PN}.fossil

		addwrite "${distdir}"

		if [[ -e "${repo}" ]]; then
			fossil pull "${FOSSIL_URI}" -R "${repo}" || die
		else
			mkdir -p "${distdir}/fossil" || die
			fossil clone "${FOSSIL_URI}" "${repo}" || die
		fi

		mkdir -p "${S}" || die
		cd "${S}" || die
		fossil open "${repo}" || die
	}
fi

src_prepare()
{
	epatch_user
}

src_configure()
{
	local myeconfargs=(
		$(use_enable debug)
		$(use_with icons)
		$(use_with gtk)
		$(use_with qt4 qt)
	    $(use_enable libnotify notification)
	)
	econf "${myeconfargs[@]}"
}

src_install()
{
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install

	use systemd && systemd_dounit src/dhcpcd-online/dhcpcd-wait-online.service
}

