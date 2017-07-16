# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: x11-themes/nimbus-gtk-theme/nimbus-gtk-theme-4.2.ebuild,v 1.1 2014/08/08 00:22:09 Exp $

EAPI=5

inherit gnome2-utils

MY_PN=${PN/k/k3}

DESCRIPTION="a gtk+:3 port of the good gtk+:2 theme"
HOMEPAGE="http://gnome-look.org/content/show.php/nimbus+gtk3+version?content=164641"
SRC_URI="http://gnome-look.org/CONTENT/content-files/164641-${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz
	icon? ( ihttp://gnome-look.org/CONTENT/content-files/164644-nimbus-icons-extras-1.1.tar.gz
		-> nimbus-icons-extras-1.1.tar.gz )
	gnome? ( http://gnome-look.org/CONTENT/content-files/164643-nimbus-muffin-theme-2.0.tar.gz
		-> nimbus-muffin-theme-2.0.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+icon gnome -minimal"

RDEPEND="minimal? ( !x11-themes/gnome-theme )
	x11-themes/nimbus
	gnome? ( x11-wm/metacity )"

DEPEND=""

S="${WORKDIR}"/${MY_PN}-${PV}

src_install() {
	insinto /usr/share/themes
	doins -r {,dark-,light-}nimbus
	use gnome && doins ../nimbus-mufin-theme-*/{,dark-,light-}nimbus

	if use icon; then
		insinto /usr/share/icons/nimbus
		doins -r ../nimbus-icons-extras-*/*
	fi
}

