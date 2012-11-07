# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/insignificant-gtk-theme/insignificant-gtk-theme-0_p20101012.ebuild,v 1.1 2012/11/07 11:31:35 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="Nice gtk2 theme by jurialmunkey"
HOMEPAGE="https://jurialmunkey.deviantart.com/art/Insignificant-182490780"
SRC_URI="http://www.deviantart.com/download/182490780/insignificant_by_jurialmunkey-d30nesc.zip -> ${P}.zip"

LICENSE="CC BY-NC-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"

RDEPEND="x11-themes/gtk-engines-murrine !minimal? ( x11-themes/gnome-themes )"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	mv Insignificant ${PN%-gtk*} || die
	mv {Insignificant,${PN%-gtk*}/${PN%-gtk*}}.emerald || die
	mv {Insignificant\ II,${PN%-gtk*}/${PN%-gtk*}-2}.emerald || die
	insinto /usr/share/themes
	doins -r insignificant* || die
}
