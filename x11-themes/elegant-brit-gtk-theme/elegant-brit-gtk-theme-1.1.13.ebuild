# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/elegant-brit-gtk-theme/elegant-brit-gtk-theme-1.1.13.ebuild,v 1.1 2012/11/07 11:28:22 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="Great desktop suite by fmrbpensador and other contributors"
HOMEPAGE="http://nosebleed.deviantart.com/"
SRC_URI="
	http://www.deviantart.com/download/90140521/Dark_Brit_by_nosebleed.gz  -> ${P/gtk/dark-gtk}.gz
	http://www.deviantart.com/download/208925032/elegant_brit_gnome3_by_grvrulz-d3gdzl4.7z -> ${PN}.7z
	http://gnome-look.org/CONTENT/content-files/85661-Elegant-Matrix.tar.gz -> ${P/gtk/dark-green-gtk}.tar.gz
	emerald? ( http://gnome-look.org/CONTENT/content-files/75983-Elegant%20Brit.emerald -> elegant-brit-1.0.2.emerald )
	xfwm4? ( http://xfce-look.org/CONTENT/content-files/76017-Elegant%20Brit.tar.gz -> ${P/gtk/xfwm4}.tar.gz )
	openbox? ( http://box-look.org/CONTENT/content-files/76462-Elegant%20Brit.obt -> ${PN/gtk/openbox}-0.1.3.obt )
	pekwm? ( http://box-look.org/CONTENT/content-files/76808-Elegant-Brit-pekwm.tar.gz -> ${P/gtk/pekwm}.tar.gz )
	macmenu? ( http://gnome-look.org/CONTENT/content-files/76235-ElegantBritMacMenu.tar.gz -> ${PN/gtk-theme/mac-menu}-1.1.1.tar.gz )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emerald gnome gtk macmenu metacity minimal openbox pekwm xfwm4"

RDEPEND="emerald? ( x11-wm/emerald )
	gtk? ( x11-themes/gnome-themes-standard )
	macmenu? ( =gnome-base/gnome-panel-2.3* )
	!minimal? ( x11-themes/gnome-themes )
	openbox? ( x11-wm/openbox )
	pekwm? ( x11-wm/pekwm )
	xfwm4? ( xfce-base/xfwm4 )
"
DEPEND="app-arch/p7zip"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	find . -type f -name '*~*' -name 'Elegant_Brit.desktop' -exec rm -f {} \;
	mv Elegant_Brit ${PN%-gtk*}; mv ${PN%-gtk*}/{,firefox-}userChrome.css
	use gtk || rm -r ${PN%-gtk*}/gtk-3.0
	use gnome || rm -r ${PN%-gtk*}/gnome-shell
	use metacity || rm -r ${PN%-gtk*}/metacity-1
	if use openbox; then
		cp "${DISTDIR}"/${PN/gtk/openbox}-0.1.3.obt ${PN%-gtk*}/${PN%-gtk*}.obt
	fi
	if use macmenu; then
		rm -r ${PN%-gtk*}/{gtk-2.0,metacity-1}
		mv Elegant\ Brit\ MacMenu ElegantBritMacMenu
		mv ElegantBritMacMenu/{gtk-2.0,metacity-1} ${PN%-gtk*}/
	fi
	tar xf ${P/gtk/dark-gtk}
	mv Dark\ Brit ${PN%-gtk*}-dark
	mv  Elegant-Matrix ${PN%-gtk*}-dark-green
	rm ${PN%-gtk*}-dark-green/README.txt
	insinto /usr/share/themes
	doins -r ${PN%-gtk*}{,-dark{,-green}} || die
	if use emerald; then
		cp {"${DISTDIR}"/${PN%-gtk*}-1.0.2,${PN%-gtk*}}.emerald
		doins ${PN%-gtk*}.emerald || die
	fi
	if use pekwm; then
		mv Elegant-Brit ${PN%-gtk*}
		insinto /usr/share/pekwm/themes
		doins -r ${PN%-gtk*} || die
	fi
}
