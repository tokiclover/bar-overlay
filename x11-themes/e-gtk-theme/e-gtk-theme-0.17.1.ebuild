# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-themes/e-gtk-theme/e-gtk-theme-0.17.0.ebuild,v 1.5 2014/11/11 14:23:22 -tclover Exp $

EAPI=5

inherit eutils

DESCRIPTION="a gtk theme to match enlightenment DR17 default theme"
HOMEPAGE="https://github.com/tokiclover/e-gtk-theme"
SRC_URI="https://github.com/tokiclover/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT=0
IUSE="gnome gtk minimal openbox"

REQUIRED_USE="gnome? ( gtk )"
GTK_VERSION="3.6"

RDEPEND="!minimal? (  !gtk? ( x11-themes/gnome-themes )
	              gtk? ( x11-themes/gnome-themes-standard ) )"

DEPEND="${RDEPEND}"

DOC=( AUTHORS ChangeLog README.md )

src_install()
{
	insinto /usr/share/themes/e
	use gnome   && doins -r metacity-1
	use gtk     && doins -r gtk-3.0
	use openbox && doins -r openbox-3
	               doins -r gtk-2.0
	dodoc "${DOC[@]}"
}

