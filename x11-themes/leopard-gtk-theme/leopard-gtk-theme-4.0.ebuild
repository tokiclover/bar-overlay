# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/leopard-gtk-theme/leopard-gtk-theme-4.0.ebuild,v 1.0 2012/07/04 00:22:09 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="A very good lepard gtk port theme"
HOMEPAGE="http://badimnk.deviantart.com/"
SRC_URI="http://gnome-look.org/CONTENT/content-files/147309-gnome-leopard.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="icon -minimal"

RDEPEND="minimal? ( !x11-themes/gnome-theme )
	x11-themes/gtk-engines-murrine
	icon? ( x11-thems/${PN/gtk/icon} )
"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	unpack ./gnome-leopard/leopard.tar.gz || die
}

src_install() {
	insinto /usr/share/themes
	doins -r leopard || die
}
