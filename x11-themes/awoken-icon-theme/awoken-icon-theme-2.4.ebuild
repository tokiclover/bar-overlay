# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/awoken-icon-theme/awoken-icon-theme-2.4.ebuild,v 1.1 2012/07/04 00:21:46 -tclover Exp $

EAPI=2

inherit gnome2-utils

DESCRIPTION="A great monochrome-ish scalable icon theme with 100³ colors and more"
HOMEPAGE="http://alecive.deviantart.com/art/"
SRC_URI="http://www.deviantart.com/download/163570862/awoken_by_alecive-d2pdw32.zip -> ${P}.zip"

LICENSE="CC BY-NC-SA-3.0 - CC BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="colorization -minimal"

RDEPEND="minimal? ( !x11-themes/gnome-icon-theme )
	colorization? ( media-gfx/imagemagick )
"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

MY_PN=AwOken
S=${WORKDIR}/${MY_PN}-${PV/-r[0-9]*}

src_prepare() {
	for theme in ${MY_PN}{,Dark}; do unpack ./$theme.tar.gz || die "eek!"; done
	local res x
	for x in ${MY_PN}{,Dark}; do
		for res in 24 128; do
			cd "${x}"/clear/${res}x${res}/places/
			ln -s -f ../start-here/start-here-gentoo1.png start-here.png || die
			ln -s -f ../start-here/start-here-gentoo1.png start-here-symbolic.png || die
			cd "${S}"
		done
	done
}

src_install() {
	mv ${MY_PN}/Installation_and_Instructions.pdf README.pdf
	dodoc README.pdf
	insinto /usr/local/bin
	doins ${MY_PN}/awoken-icon-theme-customization{,-clear} \
		${MY_PN}Dark/awoken-icon-theme-customization-dark || die "eek!"
	insinto /usr/share/icons
	mv ${MY_PN}{,Dark} "${D}"/usr/share/icons/ || die "eek!"
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() {
	gnome2_icon_cache_update
	einfo
	einfo "one should run the scripts to delete previous profile to create a"
	einfo "new one or colorize the icon set"
	einfo
}
pkg_postrm() { gnome2_icon_cache_update; }
