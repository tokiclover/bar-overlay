# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/faenza-cupertino-icon-theme/faenza-cupertino-icon-theme-0.9.2_p20110710.ebuild,v 1.1 2012/05/08 -tclover Exp $

EAPI=2

inherit gnome2-utils

DESCRIPTION="Recoloured the original Faenza theme folders."
HOMEPAGE="http://gnome-look.org/content/show.php/Faenza-Cupertino?content=129008"
SRC_URI="http://gnome-look.org/CONTENT/content-files/129008-Faenza-Cupertino.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal"

RDEPEND="minimal? ( !x11-themes/gnome-icon-theme )"
DEPEND="x11-themes/faenza-icon-theme"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/icons
	doins -r Faenza-Cupertino || die "eek!"
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
