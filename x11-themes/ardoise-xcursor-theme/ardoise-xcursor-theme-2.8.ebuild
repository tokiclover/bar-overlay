# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-themes/ardoise-xcursor-theme/ardoise-xcursor-theme-2.8.ebuild,v 1.2 2014/11/26 00:22:05 -tclover Exp $

EAPI=5

inherit gnome2-utils

DESCRIPTION="A simple, dark, flat and slightly translucent theme"
HOMEPAGE="http://gnome-look.org/content/show.php/Ardoise?content=165308"
SRC_URI="https://www.dropbox.com/s/8jas94rsqlsw1w6/Ardoise_translucent.tar.gz -> ${PN}-translucent-${PV}.tar.gz
	https://www.dropbox.com/s/l82xow7a7lx8udc/Ardoise_opaque.tar.gz -> ${PN}-opaque-${PV}.tar.gz"

LICENSE="CC-NC-SA-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal"

RDEPEND="minimal? ( !x11-themes/xcursor-themes )"
DEPEND=""

S="${WORKDIR}"

src_install()
{
	insinto /usr/share/icons
	doins -r Ardoise_{translucent,opaque}
}

pkg_preinst()
{
	gnome2_icon_savelist
}
pkg_postinst()
{
	gnome2_icon_cache_update
}
pkg_postrm()
{
	gnome2_icon_cache_update
}
