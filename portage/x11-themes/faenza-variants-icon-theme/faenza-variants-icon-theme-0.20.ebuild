# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/faenza-icon-theme/faenza-icon-theme-0.7.ebuild,v 1.4 2011/01/26 16:52:26 ssuominen Exp $

inherit gnome2-utils

DESCRIPTION="Variants from he original Faenza{,-Cupertino} icon themes."
HOMEPAGE="http://spg76.deviantart.com/art/Faenza-Variants-184551528?loggedin=1"

# nice LibreOffice LibreOffice Faenza Icons [inofficial] icons 
# from http://gnome-look.org/content/show.php?content=138339
SRC_URI="${DISTDIR}/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

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
