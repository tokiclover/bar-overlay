# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-themes/e-gtk-theme/e-gtk-theme-9999.ebuild,v 1.5 2014/11/11 14:23:25 -tclover Exp $

EAPI=5

inherit eutils git-2

DESCRIPTION="a gtk theme to match enlightenment DR17 default theme"
HOMEPAGE="https://github.com/tokiclover/e-gtk-theme"
EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"

LICENSE="BSD-2"
KEYWORDS=""
SLOT=0
IUSE="gnome gtk minimal openbox"
REQUIRED_USE="gnome? ( gtk )"

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

