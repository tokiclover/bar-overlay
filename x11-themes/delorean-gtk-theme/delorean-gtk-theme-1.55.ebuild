# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/delorean-gtk-theme/delorean-gtk-theme-1.55.ebuild,v 1.2 2012/11/04 04:41:44 -tclover Exp $

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
IUSE="chromium cinnamon firefox gnome gtk metacity openbox thunderbird xfwm4"

RDEPEND="chromium? ( www-client/chromium )
	cinnamon? ( gnome-extra/cinnamon )
	firefox? ( || ( www-client/firefox www-client/firefox-bin ) )
	metacity? ( x11-wm/metacity )
	gnome? ( gnome-base/gnome-shell )
	gtk? ( x11-themes/gnome-themes-standard )
	openbox? ( x11-wm/openbox )
	thunderbird? ( || ( mail-client/thunderbird mail-client/thunderbird-bin ) )
	xfwm4? ( xfce-base/xfwm4 )"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_install() {
	rm -r delorean-dark/{unity,Software-Center} || die
	if use firefox; then
		mv DeLorean-Dark-Firefox_1.60 delorean-dark/firefox || die
		mv delorean-dark/firefox/{READ_ME-INSTALL,README}
	fi
	if use chromium; then
		cp -r Chromium-Themes delorean-dark/chromium || die
		mv delorean-dark/chromium/DeLorean-Chromium.crx \
			delorean-dark/chromium/delorean.crx || die
		mv delorean-dark/chromium/DeLorean-Dark-Chromium.crx \
			delorean-dark/chromium/delorean-dark.crx || die
		mv delorean-dark/chromium/varNaM-Chromium.crx \
			delorean-dark/chromium/varnam.crx || die

	else
		rm -r delorean-dark/Software-Center || die
	fi
	if use thunderbird; then
		mv DeLorean-Dark-Thunderbird_1.10 delorean-dark/thunderbird || die
		rm delorean-dark/thunderbird/READ_ME-INSTALL\~ || die
		mv delorean-dark/thunderbird/READ{_ME-INSTALL,ME} || die
	fi
	use cinnamon || rm -r delorean-dark/cinnamon
	use gnome || rm -r delorean-dark/gnome-shell
	use openbox || rm -r delorean-dark/openbox-3
	use metacity || rm -r delorean-dark/metacity-1
	use xfwm4 || rm -r delorean-dark/xfwm4
	insinto /usr/share/themes
	doins -r delorean-dark
}
