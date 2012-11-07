# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/elementary-gtk-theme/elementary-gtk-theme-3.1.ebuild,v 1.2 2012/11/07 11:30:05 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="elemenatry gtk theme by danrabbit"
HOMEPAGE="http://danrabbit.deviantart.com/art/elementary-gtk-theme-83104033"
SRC_URI="http://www.deviantart.com/download/83104033/${PN/-/_}_by_danrabbit-d1dh7hd.zip -> ${P}.zip
openbox? ( http://www.deviantart.com/download/253002995/elementary_for_openbox_by_grvrulz-d46mqcz.zip
	-> ${P/gtk/openbox}.zip )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk metacity minimal openbox xfwm4"

RDEPEND="x11-themes/gtk-engines-murrine
	metacity? ( x11-wm/metacity )
	!minimal? ( x11-themes/gnome-themes )
	gtk? ( x11-themes/gnome-themes-standard )
	openbox? ( x11-wm/openbox )
"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	find . -type f -name '*~*' -exec rm -f {} \;
	local pn=${PN%%-*}
	dodoc ${pn}/{AUTHORS,CONTRIBUTORS}
	rm -fr ${pn}/{.bzr,COPYING,AUTHORS,CONTRIBUTORS}
	use metacity || rm -fr ${pn}/metacity-1
	use gtk || rm -fr ${pn}/gtk-3.0
	use openbox && mv {egtk,elementary/}.obt
	insinto /usr/share/themes
	doins -r ${pn} || die
}
