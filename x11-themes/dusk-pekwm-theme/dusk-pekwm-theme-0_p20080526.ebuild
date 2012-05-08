# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/dusk-pekwm-theme-0_p20080526.ebuild,v 1.1 2012/05/05 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="A pekwm theme together with a gtk theme by thrynk"
HOMEPAGE="http://thrynk.deviantart.com/"
SRC_URI="
	http://www.deviantart.com/download/86758314/Dusk_Pekwm_by_thrynk.gz -> ${P}.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bmpanel gtk -minimal"

RDEPEND="x11-wm/pekwm
	bmpanel? ( x11-misc/bmpanel )
	media-fonts/artwiz-latin1
"
DEPEND="minimal? ( !x11-themes/gnome-theme )
"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_prepare() {
	tar xf ./${P} || die
}

src_install() {
	insinto /usr/share/pekwm/themes
	tar xf Dusk/Dusk-pekwm.tar.gz -C "${D}"/usr/share/pekwm/themes/ || die "eek!"
	mv "${D}"/usr/share/pekwm/themes/{D,d}usk
	use gtk && {
		insinto /usr/share/themes
		tar xf Dusk/Dusk-gtk.tar.gz -C "${D}"/usr/share/themes/ || die "eek!"
		mv "${D}"/usr/share/themes/{D,d}usk
	}
	use bmpanel && {
		insinto /usr/share/bmpanel/themes
		tar xf Dusk/Dusk-bmpanel.tar.gz -C "${D}"/usr/share/bmpanel/themes/ || die
		mv "${D}"/usr/share/bmpanel/themes/{D,d}usk
	}
}
