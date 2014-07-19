# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-themes/e-gtk-theme/e-gtk-theme-0.16.0.ebuild,v 1.2 2014/07/15 14:23:22 -tclover Exp $

EAPI="5"

inherit eutils

DESCRIPTION="a gtk theme to match enlightenment DR17 default theme"
HOMEPAGE="https://github.com/tokiclover/e-gtk-theme"
SRC_URI="https://github.com/tokiclover/${PN}/tarball/${PVR} -> ${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT=0
IUSE="gnome gtk minimal openbox"

REQUIRED_USE="gnome? ( gtk )"
GTK_VERSION="3.6"

RDEPEND="gnome? ( x11-wm/metacity )
	!minimal? (  || ( >=x11-themes/gnome-themes-standard-${GTK_VERSION} x11-themes/gnome-themes ) )
	openbox? ( x11-wm/openbox:3 )"

DEPEND="!gnome? ( x11-libs/gtk+:2 ) gtk? ( >=x11-libs/gtk+-${GTK_VERSION}:3 )"

DOC=( AUTHORS COPYING README.md )

src_unpack() {
	default
	mv *${PN}* ${P}
}

src_install() {
	insinto /usr/share/themes/e
	use gnome   && doins -r metacity-1
	use gtk     && doins -r gtk-3.0
	use openbox && doins -r openbox-3
	               doins -r gtk-2.0
	dodoc "${DOC[@]}"
}
