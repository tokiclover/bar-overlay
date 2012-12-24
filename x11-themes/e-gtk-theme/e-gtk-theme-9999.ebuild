# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/x11-themes/e-gtk-theme/e-gtk-theme-9999.ebuild,v 1.1 2012/12/24 00:03:03 -tclover Exp $

EAPI=4

inherit eutils git-2

DESCRIPTION="a gtk theme to match enlightenment DR17 default theme"
HOMEPAGE="https://github.com/tokiclover/e-gtk-theme"
EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"

LICENSE="GPL-2"
KEYWORDS=""
SLOT=0
IUSE="gnome gtk minimal openbox"
REQUIRED_USE="gtk? ( gnome )"

RDEPEND="x11-wm/enlightenment
	!gnome? ( x11-libs/gtk+:2 )
	gnome? ( x11-wm/metacity )
	gtk? ( x11-themes/gnome-themes-standard )
	!minimal? ( x11-themes/gnome-themes )
	openbox? ( x11-wm/openbox:3 )"
DEPEND=""

DOC=( README )

src_install() {
	cd "${WORKDIR}" && mv ${P} e
	use gnome   || rm -r e/metacity-1
	use gtk     || rm -r e/gtk-3
	use openbox || rm -r e/openbox-1
	insinto /usr/share/themes
	doins -r e || die
}
