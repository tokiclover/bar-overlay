# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/x11-themes/elementary-gtk-theme/elementary-gtk-theme-2.1.ebuild, v1.1 2011/09/08 Exp $

inherit eutils

DESCRIPTION="The infamous gtk2 theme by DanRabbit"
HOMEPAGE="http://danrabbit.deviantart.com/art/elementary-gtk-theme-83104033"
SRC_URI="http://www.deviantart.com/download/83104033/elementary_gtk_theme_by_danrabbit-d1dh7hd.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"
EAPI=2

RDEPEND="minimal? ( !x11-themes/gnome-theme )
		x11-themes/gtk-engines-murrine"
DEPEND="app-arch/unzip"

#RESTRICT="binchecks strip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_install() {
	rm -rf egtk/{.bzr,debian} || die "eek!"
	mv egtk ${PN/-theme} || die "eek!"
	insinto /usr/share/themes
	doins -r ${PN/-theme} || die "eek!"
	dodoc AUTHORS CONTRIBUTORS
}
