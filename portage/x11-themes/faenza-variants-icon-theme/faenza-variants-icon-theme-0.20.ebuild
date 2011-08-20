# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/x11-themes/faenza-variants-icon-theme/faenza-variants-icon-theme-0.20.ebuild,v1.1 2011/08/18 Exp $

inherit gnome2-utils

DESCRIPTION="Variants from he original Faenza{,-Cupertino} icon themes."
HOMEPAGE="http://spg76.deviantart.com/art/Faenza-Variants-184551528?loggedin=1"

SRC_URI="http://www.deviantart.com/download/184551528/faenza_variants_by_spg76-d31vkvc.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
EAPI=2

DEPEND="app-arch/unzip"
RDEPEND="x11-themes/faenza-cupertino-icon-theme"

RESTRICT="binchecks strip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_install() {
	for i in Faenza-Variants{,-Dark,-Cupertino}; do
		unpack ./${i}.tar.gz
	done
	insinto /usr/share/icons
	doins -r Faenza-Variants{,-Dark,-Cupertino} || die "eek!"
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
