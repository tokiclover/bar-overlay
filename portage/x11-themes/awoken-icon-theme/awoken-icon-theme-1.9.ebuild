# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/x11-themes/awoken-icon-theme/awoken-icon-theme-1.9.ebuild,v1.4 2011/08/18 Exp $

inherit gnome2-utils

DESCRIPTION="A scalable icon theme called AwOken"
HOMEPAGE="http://alecive.deviantart.com/art/AwOken-163570862"
SRC_URI="${DISTDIR}/${P}.zip"

LICENSE="CC BY-NC-SA-3.0 - CC BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"

RDEPEND="!minimal? ( x11-themes/gnome-icon-theme )"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

PNC=AwOken
S=${WORKDIR}/${PNC}-${PV}

src_unpack() {
	unpack ${A}
}

src_install() {
	unpack ./${PNC}.tar.gz
	unpack ./${PNC}Dark.tar.gz
	mv ./${PNC}/Installation_and_Instructions.pdf README.pdf
	dodoc README.pdf
	dodir /usr/share/icons
	for i in ${PNC}{,Dark}; do mv ./${i} "${D}"/usr/share/icons; done || die "eek!"
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
