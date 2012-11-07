# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/valium-gtk-theme/valium-gtk-theme-0_p20071012.ebuild,v 1.1 2012/11/07 12:21:23 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="A nice dark gtk and pekwm theme"
HOMEPAGE="http://kalushary.deviantart.com/"
SRC_URI="http://www.deviantart.com/download/175285785/valium_by_kalushary-d2wczdl.zip -> ${P}.zip"

LICENSE="CC BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bmpanel minimal pekwm"
EAPI=2

RDEPEND="minimal? ( !x11-themes/gnome-theme )
	pekwm? ( x11-wm/pekwm ) bmpanel? ( x11-misc/bmpanel )"

DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	mv {V,v}alium || die; mv {${PN%-gtk*}/,}pekwm
	if use bmpanel; then
		insinto /usr/share/bmpanel/themes
		doins -r ${PN%-gtk*}/bmpanel || die
	else rm -r ${PN-gtk*}/bmpanel; fi
	insinto /usr/share/themes
	doins -r ${PN%-gtk*} || die
	if use pekwm; then
		mv pekwm ${PN%-gtk*}
		insinto /usr/share/pekwm/themes
		doins -r ${P%-gtk*}/pekwm || die
	else rm -r ${PN%-gtk*}; fi
}
