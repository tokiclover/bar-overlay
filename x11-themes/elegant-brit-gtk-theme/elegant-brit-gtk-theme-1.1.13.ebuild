# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/elegant-brit-gtk-theme/elegant-brit-gtk-theme-1.1.13.ebuild,v 1.1 2012/05/08 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="Great desktop suite by fmrbpensador and other contributors"
HOMEPAGE="http://nosebleed.deviantart.com/"
SRC_URI="
	http://www.deviantart.com/download/90140521/Dark_Brit_by_nosebleed.gz  -> ${P/gtk/dark-gtk}.gz
	gtk3? ( http://www.deviantart.com/download/208925032/elegant_brit_gnome3_by_grvrulz-d3gdzl4.7z 
			-> ${PN/gtk/gtk3}-0_p20111015.7z )
	http://gnome-look.org/CONTENT/content-files/85661-Elegant-Matrix.tar.gz -> ${P/gtk/dark-green-gtk}.tar.gz
	http://gnome-look.org/CONTENT/content-files/74553-ElegantBrit.tar.gz -> ${P}.tar.gz
	emerald? ( http://gnome-look.org/CONTENT/content-files/75983-Elegant%20Brit.emerald 
			   -> elegant-brit-1.0.2.emerald )
	xfwm?    ( http://xfce-look.org/CONTENT/content-files/76017-Elegant%20Brit.tar.gz 
			   -> ${P/gtk/xfwm}.tar.gz )
	openbox? (
			  http://box-look.org/CONTENT/content-files/76462-Elegant%20Brit.obt
			  -> ${PN/gtk/openbox}-0.1.3.obt )
	pekwm?   ( http://box-look.org/CONTENT/content-files/76808-Elegant-Brit-pekwm.tar.gz 
			   -> ${P/gtk/pekwm}.tar.gz )
	macmenu? ( http://gnome-look.org/CONTENT/content-files/76235-ElegantBritMacMenu.tar.gz 
				-> ${PN/gtk-theme/mac-menu}-1.1.1.tar.gz )
	wallpaper? ( http://gnome-look.org/CONTENT/content-files/76847-FreeAsInBeauty.tar.gz 
				 -> ${PN/gtk-theme/freeasinbeauty}-1.0.2.tar.gz )
	gdm?       ( http://gnome-look.org/CONTENT/content-files/76929-brit-waves-0.2.tar.bz2 
				 -> ${PN/gtk-theme/gdm-wave}-0.2.tar.bz2 )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emerald gdm gtk3 macmenu -minimal openbox pekwm xfwm wallpaper"

RDEPEND="minimal? ( !x11-themes/gnome-theme )
	emerald?  ( x11-wm/emerald )
	gdm?      ( gnome-base/gdm )
	macmenu? ( gnome-base/gnome-panel )
	openbox?  ( x11-wm/openbox )
	pekwm?    ( x11-wm/pekwm )
	xfwm?     ( xfce-base/xfwm4 )
"
DEPEND="gtk3? ( app-arch/p7zip )"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	mv Elegant\ Brit ${PN%-gtk*}
	if use macmenu; then
		rm -r ${PN%-gtk*}/{gtk-2.0,metacity-1}
		mv Elegant\ Brit\ MacMenu ElegantBritMacMenu
		mv ElegantBritMacMenu/{gtk-2.0,metacity-1} ${PN%-gtk*}/
	fi
	if use gtk3; then
		mv Elegant_Brit/gnome-shell ${PN%-gtk*}/ || die "eek!"
		mv Elegant_Brit/gtk-3.0 ${PN%-gtk*}/ || die "eek!"
	fi
	tar xf ${P/gtk/dark-gtk}
	mv Dark\ Brit ${PN%-gtk*}-dark
	mv  Elegant-Matrix ${PN%-gtk*}-dark-green
	insinto /usr/share/themes
	doins -r ${PN%-gtk*}{,-dark{,-green}} || die "eek!"
	if use emerald; then
		cp {"${DISTDIR}"/${PN%-gtk*}-1.0.2,${PN%-gtk*}}.emerald
		doins ${PN%-gtk*}.emerald || die "eek!"
	fi
	if use openbox; then
		cp "${DISTDIR}"/${PN/gtk/openbox}-0.1.3.obt ${PN%-gtk*}.obt
		doins ${PN%-gtk*}.obt || die "eek!"
	fi
	if use pekwm; then
		mv Elegant-Brit ${PN%-gtk*}
		insinto /usr/share/pekwm/themes
		doins -r ${PN%-gtk*} || die "eek!"
		insinto /usr/share/font/TTF
		doins slkscr.ttf || die "eek!"
	fi
	if use gdm; then
		insinto /usr/share/gdm/autostart
		doins -r brit-waves || die "eek!"
	fi
	if use wallpaper; then
		insinto /usr/share/gdm/freeasinbeauty
		doins *.svg || die "eek!"
	fi
}
