# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/x11-themes/delorean-gtk-theme/delorean-gtk-theme-1.55.ebuild,v 1.2 2013/01/06 11:14:41 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="A nice dark metal brushed gtk theme"
HOMEPAGE="http://killhellokitty.deviantart.com/"
SRC_URI="http://www.deviantart.com/download/318612217/delorean_dark_1_55_by_killhellokitty-d59oyrd.zip -> ${P}.zip
	chromium? ( http://www.deviantart.com/download/319908432/chromium_themes_by_killhellokitty-d5agqxc.zip 
			   -> ${PN/gtk/chromium}-1.01.zip )
	firefox? ( http://www.deviantart.com/download/326668996/delorean_dark_firefox_theme_1_60_by_killhellokitty-d5ehnes.zip
			  -> ${PN/gtk/firefox}-1.60.zip )
	thunderbird? ( http://www.deviantart.com/download/328142149/delorean_dark_thunderbird_theme_1_10_by_killhellokitty-d5fd83p.zip
				  -> ${PN/gtk/thunderbird}-1.10.zip )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="chromium cinnamon firefox gnome gtk metacity minimal openbox thunderbird xfwm4"

RDEPEND="chromium? ( www-client/chromium )
	cinnamon? ( gnome-extra/cinnamon )
	firefox? ( || ( www-client/firefox www-client/firefox-bin ) )
	metacity? ( x11-wm/metacity )
	!minimal? ( x11-themes/gnome-themes )
	gnome? ( gnome-base/gnome-shell )
	gtk? ( =x11-themes/gnome-themes-standard-3.4* )
	openbox? ( x11-wm/openbox )
	thunderbird? ( || ( mail-client/thunderbird mail-client/thunderbird-bin ) )
	xfwm4? ( xfce-base/xfwm4 )
	x11-themes/gtk-engines-unico
	x11-themes/gtk-engines
	>=x11-themes/gtk-engines-murrine-0.98.1.1
	>=x11-themes/gtk-engines-equinox-1.50"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	rm -r delorean-dark/{unity,Software-Center} || die
	if use firefox; then
		mkdir -p delorean-dark/apps/firefox
		mv DeLorean-Dark-Firefox_1.60/chrome \
			delorean-dark/apps/firefox || die
		mv DeLorean-Dark-Firefox_1.60/READ_ME-INSTALL \
			delorean-dark/apps/firefox/README
	fi
	if use chromium; then
		mkdir -p delorean-dark/apps/chromium
		mv Chromium-Themes/DeLorean-Chromium.crx \
			delorean-dark/chromium/delorean.crx || die
		mv Chromium-Themes/DeLorean-Dark-Chromium.crx \
			delorean-dark/chromium/delorean-dark.crx || die
		mv Chromium-Themes/varNaM-Chromium.crx \
			delorean-dark/chromium/varnam.crx || die
	fi
	if use thunderbird; then
		mkdir -p delorean-dark/apps/thunderbird
		mv DeLorean-Dark-Thunderbird_1.10/chrome \
			delorean-dark/apps/thunderbird || die
		mv DeLorean-Dark-Thunderbird_1.10/EAD_ME-INSTALL \
			delorean-dark/apps/thunderbird/README || die
	fi
	use cinnamon || rm -r delorean-*/cinnamon
	use gnome || rm -r delorean-*/gnome-shell
	use openbox || rm -r delorean-*/openbox-3
	use metacity || rm -r delorean-*/metacity-1
	use xfwm4 || rm -r delorean-*/xfwm4
	insinto /usr/share/themes
	doins -r delorean-dark
}
