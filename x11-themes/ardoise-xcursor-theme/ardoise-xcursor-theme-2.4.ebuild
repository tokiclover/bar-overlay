# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-themes/ardoise-xcursor-theme/ardoise-xcursor-theme-2.4.ebuild,v 1.1 2014/07/31 00:22:05 -tclover Exp $

EAPI=5

inherit gnome2-utils

DESCRIPTION="A simple, dark, flat and slightly translucent theme"
HOMEPAGE="http://gnome-look.org/content/show.php/Ardoise?content=165308"
SRC_URI="http://gnome-look.org/CONTENT/content-files/165308-Ardoise.tar.gz -> ${P}.tar.gz"

LICENSE="CC-NC-SA-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal"

RDEPEND="minimal? ( !x11-themes/xcursor-themes )"
DEPEND=""

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	mv ardoise{_debug,} || die
	insinto /usr/share/icons
	doins -r ardoise
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
