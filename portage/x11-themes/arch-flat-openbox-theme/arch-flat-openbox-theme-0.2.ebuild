# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/x11-themes/arch-flat-openbox-theme-0.2.ebuild,v 1.1 2011/09/10 -tclover Exp $

inherit eutils

DESCRIPTION="arch.flat - openbox themes that is based on arch.blue with color...blue, lime, gold, red, pink"
HOMEPAGE="http://box-look.org/content/show.php/arch.flat?content=143137"
SRC_URI="http://box-look.org/CONTENT/content-files/143137-arch.flat-0.2.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"
EAPI=2

RDEPEND="minimal? ( !x11-themes/gnome-theme )
		x11-wm/openbox"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_install() {
	insinto /usr/share/themes
	doins  arch.*.obt || die "eek!"
}
