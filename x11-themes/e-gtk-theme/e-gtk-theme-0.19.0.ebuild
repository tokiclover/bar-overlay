# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-themes/e-gtk-theme/e-gtk-theme-0.18.0.ebuild,v 1.6 2014/11/21 14:23:22 -tclover Exp $

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

DEPEND=""
RDEPEND="!minimal? ( gtk? ( x11-themes/gnome-themes-standard ) )
	x11-themes/gtk-engines"

src_install()
{
	sed -e '/.*COPYING.*$/d' -i Makefile
	local themedir=/usr/share/themes/e
	emake DESTDIR="${ED}" prefix=/usr install-all
	use gnome   || rm -fr "${ED}"/${themedir}/metacity-1
	use openbox || rm -fr "${ED}"/${themedir}/openbox-3
}

