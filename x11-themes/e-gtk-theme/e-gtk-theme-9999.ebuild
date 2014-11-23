# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-themes/e-gtk-theme/e-gtk-theme-9999.ebuild,v 1.6 2014/11/21 14:23:25 -tclover Exp $

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

src_install()
{
	sed -e '/.*COPYING.*$/d' -i Makefile
	local themedir=/usr/share/themes/e
	emake DESTDIR="${ED}" VERSION=${PV} prefix=/usr install-all
	use gnome   || rm -fr "${ED}"/${themedir}/metacity-1
	use openbox || rm -fr "${ED}"/${themedir}/openbox-3
}

