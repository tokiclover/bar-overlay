# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-misc/dhcpcd-ui/dhcpcd-ui-9999.ebuild,v 1.2 2014/11/08 18:29:24 -tclover Exp $

EAPI=5

if [[ "${PV}" == 9999* ]]; then
	DEPEND="dev-vcs/fossil"
else
	SRC_URI="http://roy.marples.name/downloads/${PN%-ui}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

inherit eutils systemd

DESCRIPTION="Desktop notification and configuration for dhcpcd"
HOMEPAGE="http://roy.marples.name/projects/dhcpcd-ui/"

LICENSE="BSD-2"
SLOT="0"
IUSE="debug gtk gtk3 icons qt4 libnotify"
REQUIRED_USE="|| ( gtk gtk3 qt4 )
	gtk3? ( !gtk ) gtk? ( !gtk3 )
	qt4? ( icons )"

DEPEND="${DEPEND}
	virtual/libintl
	libnotify? (
		gtk?  ( x11-libs/libnotify )
		gtk3? ( x11-libs/libnotify )
		qt4?  ( kde-base/kdelibs )
	)
	gtk?  ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	qt4?  ( dev-qt/qtgui:4 )"

RDEPEND=">=net-misc/dhcpcd-6.4.4
	!icons? ( x11-themes/hicolor-icon-theme )"

src_unpack()
{
	if [[ "${PV}" == 9999* ]]; then
		local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"/fossil-src
		local repo="${distdir}"/${PN}.fossil

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
	else
		default
	fi
}

src_prepare()
{
	epatch_user
}

src_configure()
{
	local myeconfargs=(
		$(use_enable debug)
		$(use_with icons)
		$(usex gtk  '--with-gtk=gtk+-2.0' '')
		$(usex gtk3 '--with-gtk=gtk+-3.0' '')
		$(use_with qt4 qt)
		$(use_enable libnotify notification)
	)
	econf "${myeconfargs[@]}"
}

src_install()
{
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install

	systemd_dounit src/dhcpcd-online/dhcpcd-wait-online.service
}

