# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-misc/dhcpcd-ui/dhcpcd-ui-0.7.2.ebuild,v 1.1 2014/09/17 18:29:24 -tclover Exp $

EAPI=5

inherit systemd

DESCRIPTION="Desktop notification and configuration for dhcpcd"
HOMEPAGE="http://roy.marples.name/projects/dhcpcd-ui/"
SRC_URI="http://roy.marples.name/downloads/dhcpcd/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gtk gtk3 icons qt4 systemd libnotify"

DEPEND="virtual/libintl
	libnotify? ( virtual/notification-daemon )
	gtk?  ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	qt4?  ( dev-qt/qtgui )"

RDEPEND="${DEPEND}
	!icons? ( x11-themes/hicolor-icon-theme )"

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_with icons)
		$(use_with gtk)
		$(use_with qt4 qt)
	    $(use_enable libnotify notification)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install

	use systemd && systemd_dounit src/dhcpcd-online/dhcpcd-wait-online.service
}

