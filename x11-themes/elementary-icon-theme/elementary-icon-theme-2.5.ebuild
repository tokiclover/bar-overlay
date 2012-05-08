# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/elementary-icon-theme-2.5,v 1.1 2012/05/05 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="The infamous elementary[OS] icon theme"
HOMEPAGE="http://danrabbit.deviantart.com/art/"
SRC_URI="http://www.deviantart.com/download/65437279/elementary_icons_by_danrabbit-d12yjq7.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal"

RDEPEND="minimal? ( !x11-themes/gnome-icon-theme )"

RESTRICT="binchecks strip"

S="${WORKDIR}"/icons

src_install() {
	unpack ./elementary.tar.gz || die "eek!"
	unpack ./elementary-mono-dark.tar.gz || die "eek!"
	insinto /usr/share/icons
	doins -r elementary{,-mono-dark} || die "eek!"
}
