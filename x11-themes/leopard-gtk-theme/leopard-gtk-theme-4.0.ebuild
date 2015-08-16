# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-themes/leopard-gtk-theme/leopard-gtk-theme-4.0.ebuild,v 1.2 2015/08/16 00:22:09 Exp $

EAPI=5

inherit gnome2-utils

DESCRIPTION="A very good lepard gtk port theme"
HOMEPAGE="http://badimnk.deviantart.com/"
SRC_URI="http://gnome-look.org/CONTENT/content-files/147309-gnome-leopard.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="icon"

RDEPEND="x11-themes/gtk-engines-murrine
	icon? ( ${CATEGORY}/${PN/gtk/icon} )"
DEPEND="app-arch/unzip"

RESTRICT="mirror"
S="${WORKDIR}"

src_prepare()
{
	unpack ./gnome-leopard/leopard.tar.gz
}

src_install()
{
	insinto /usr/share/themes
	doins -r leopard
}

