# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/x11-themes/e-gtk-theme/e-gtk-theme-9999.ebuild,v 1.1 2012/12/30 14:23:25 -tclover Exp $

EAPI=4

inherit eutils git-2

DESCRIPTION="a gtk theme to match enlightenment DR17 default theme"
HOMEPAGE="https://github.com/tokiclover/e-gtk-theme"
EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"

LICENSE="BSD-2"
KEYWORDS=""
SLOT=0
IUSE="gnome gtk minimal openbox"
REQUIRED_USE="gtk? ( gnome )"

RDEPEND="gnome? ( x11-wm/metacity )
	!minimal? ( x11-themes/gnome-themes )
	openbox? ( x11-wm/openbox:3 )"

DEPEND="!gnome? ( x11-libs/gtk+:2 )
	gtk? ( =x11-libs/gtk-3.6*:3 )"

DOC=( AUTHORS COPYING README.md )

src_install() {
	insinto /usr/share/themes/e
	use gnome   && doins -r metacity-1
	use gtk     && doins -r gtk-3.0
	use openbox && doins -r openbox-3
	               doins -r gtk-2.0
	dodoc "${DOC[@]}"
}
