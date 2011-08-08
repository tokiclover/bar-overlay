# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/faenza-icon-theme/faenza-icon-theme-0.7.ebuild,v 1.4 2011/01/26 16:52:26 ssuominen Exp $

inherit gnome2-utils

DESCRIPTION="GT3 cursor themes ported to *nix."
HOMEPAGE="http://kde-look.org/content/show.php/GT3?content=106536"
SRC_URI="${DISTDIR}/GT3-colors-pack.rar"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"

RDEPEND="!minimal? ( x11-themes/xcursor-themes )"
DEPEND="app-arch/unrar"

RESTRICT="binchecks strip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_install() {
	for i in GT3{,-azure,-bronze,-light,-red}; do unpack ./${i}.tar.gz; done
	insinto /usr/share/icons
	doins -r GT3{,-azure,-bronze,-light,-red} || die "eek!"
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
