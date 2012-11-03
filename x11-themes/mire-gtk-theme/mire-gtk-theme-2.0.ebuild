# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/mire-gtk-theme/mire-gtk-theme-2.0.ebuild,v 1.1 2012/11/03 21:58:57 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="A nice theme in five colour, blue, lime, orange, pink and grey"
HOMEPAGE="http://gnome-look.org/content/show.php/MurrinaMire+v2+themepack?content=51023"
SRC_URI="http://gnome-look.org/CONTENT/content-files/51023-Mire%20v2.tar.gz -> ${P}.tar.gz
	fluxbox? ( http://box-look.org/CONTENT/content-files/59532-Mire%20v2-fluxbox.tar.gz
			  -> ${P/gtk/fluxbox}.tar.gz )
	openbox? ( http://box-look.org/CONTENT/content-files/60195-Mire%20v2-openbox.tar.gz
			  -> ${P/gtk/openbox}.tar.gz )
	conky?   ( http://gnome-look.org/CONTENT/content-files/58555-conky_twolines.tar.gz
			  -> ${PN/gtk/conky}-0.2.tar.gz )
	pekwm?   ( http://box-look.org/CONTENT/content-files/72951-Mirev2-pekwm.tar.gz
			  -> ${P/gtk/pekwm}.tar.gz 
			  axonkolor? ( http://box-look.org/CONTENT/content-files/75880-AXONKOLOR-pekwm.tar.gz
			  			  -> ${PN/mire-gtk/axonkolor-pekwm}-0_p20080225.tar.gz )
	)
	gtk? ( http://www.deviantart.com/download/323172555/mirev2_gtk3_by_thrynk-d5cepjf.zip
		   -> ${P/gtk/gtk3}.zip )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="axonkolor conky fluxbox gtk metacity openbox pekwm tint2 xfwm4"

RDEPEND=" x11-themes/gtk-engines-murrine
	conky?    ( app-admin/conky )
	fluxbox?  ( x11-wm/fluxbox )
	openbox?  ( >=x11-wm/openbox-3.4 )
	pekwm?    ( x11-wm/pekwm )
	gtk?      ( x11-themes/gnome-themes-standard )
	tint2?    ( x11-misc/tint2 )
	xfwm4?    ( xfce-base/xfwm4 )"

DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	if use conky; then
		mv conky mire; mv mire/{ReadMe,README}; mv mire/{.,}conkyrc
		rm -r mire/arch-updates; mv mire/{.conkyrc_gmail,conkyrc-gmail}
		mv mire/{.conkyweatherrc,conkyrc-weather}
		for file in conkyrc{,-gmail,-weather}; do
			sed -e 's:\~/scripts/.conkyweatherrc:/usr/share/conky/themes/mire/conkyrc-weather:g' \
				-e 's:\~/scripts/gmail.py:/usr/share/conky/themes/mire/gmail.py:g' \
				-e 's:|\ \${color} Arch-pkg.*conky-updates.pl}  |::g' \
				-i mire/$file || die
		done
		insinto /usr/share/conky/themes
		doins -r mire
	fi
	if use pekwm; then
		for theme in Mirev2-{blue,grey,lime,orange,pink}
		do mv ${theme} ${theme/Mirev2-/mire-}; done
		insinto /usr/share/pekwm/themes
		doins -r mire-* || die
		rm -r mire-*
		if use axonkolor; then
			insinto /usr/share/fonts/TTF
			doins stan0755.ttf || die
			insinto /usr/share/pekwm/themes
			mv AXONKOLOR axonkolor
			doins -r axonkolor || die
		fi
	fi
	for theme in Blue Grey Lime lilac Orange Pink; do
		mv Mire\ v2_${theme} mire-${theme,} || die
		use tint2 && mv mire-${theme,}/{Mirev2${theme,}.,}tint2rc ||
			rm mire-${theme,}/{Mirev${theme,}
		if use fluxbox && [ "${theme}" != "lilac" ]; then
			mkdir -p styles/mire-${theme,}
			mv Mire\ v2/Mirev2_${theme}/* styles/mire-${theme,}
		fi
		use openbox || rm -r mire-${theme,}/openbox-3
		use xfwm4 || rm -r mire-${theme,}/xfwm4
		use metacity || rm -r mire-${theme,}/metacity-1
	done
	insinto /usr/share/themes
	doins -r mire-* || die
	if use fluxbox; then
		insinto /usr/share/fluxbox
		doins -r styles || die
	fi
}
