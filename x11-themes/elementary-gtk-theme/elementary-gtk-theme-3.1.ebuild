# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/x11-themes/elementary-gtk-theme-2.1.ebuild,v 1.2 2012/05/04 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="The infamous elemenatry[OS] gtk theme"
HOMEPAGE="http://danrabbit.deviantart.com/art/elementary-gtk-theme-83104033"
SRC_URI="http://www.deviantart.com/download/83104033/${PN/-/_}_by_danrabbit-d1dh7hd.zip -> ${P}.zip
openbox? ( http://www.deviantart.com/download/253002995/elementary_for_openbox_by_grvrulz-d46mqcz.zip -> ${P/gtk/openbox}.zip )
shell? ( http://www.deviantart.com/download/251536124/gnome_shell___elementary_by_half_left-d45raik.zip -> ${P/gtk/gnome-shell}.zip )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome gtk gtk3 minimal openbox shell xfwm4"

RDEPEND="minimal? ( !x11-themes/gnome-theme )
	x11-themes/gtk-engines-murrine
	shell? ( =gnome-base/gnome-shell-3.2* 
		 =gnome-extra/gnome-tweak-tool-3.2*
	)
	xfwm4? ( xfce-base/xfwm4 )
	gnome? ( x11-wm/metacity )
	gtk3? ( x11-libs/gtk+:3 )
	openbox? ( x11-wm/openbox )
"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	local pn=${PN%%-*}
	dodoc ${pn}/{AUTHORS,CONTRIBUTORS}
	rm -fr ${pn}/{.bzr,COPYING,AUTHORS,CONTRIBUTORS}
	if ! use gnome; then rm -fr ${pn}/metacity-1 || die; fi
	if ! use gtk; then rm -fr ${pn}/gtk-2.0 || die; fi
	if ! use gtk3; then rm -fr ${pn}/gtk-3.0 || die; fi
	if ! use xfwm4; then rm -fr ${pn}/xfwm4 || die; fi
	if use openbox; then mv e{gtk,lementary/eopenbox}.obt || die; fi
	if use shell; then mv ${pn/#e/E}-3.2/gnome-shell ${pn} || die; fi
	insinto /usr/share/themes
	doins -r ${pn} || die
}
