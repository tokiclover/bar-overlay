# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/x11-themes/mire-gtk-theme-2.0.ebuild,v 1.1 2011/11/10 -tclover Exp $

inherit eutils

DESCRIPTION="A port of the popular Mire v2 suite for Windows with 5 colour 
schemes, blue, lime, orange, pink and grey"
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
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="axonkolor conky emerald fluxbox minimal openbox pekwm xfwm"
EAPI=2

RDEPEND="minimal? ( !x11-themes/gnome-theme )
		x11-themes/gtk-engines-murrine
		conky?    ( app-admin/conky )
		fluxbox?  ( x11-wm/fluxbox )
		openbox?  ( >=x11-wm/openbox-3.4 )
		pekwm?    ( x11-wm/pekwm )
"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

S=${WORKDIR}

src_install() {
	use conky && {
		mv conky mire; mv mire/{ReadMe,README}
		mv mire/{arch-updates/,}conky-updates.pl; rm -r mire/arch-updates; mv mire/{.,}conkyrc
		mv mire/{.conkyrc_gmail,conkygmailrc}; mv mire/{.conkyweatherrc,mire-weather}
		for fle in conky{,gmail}rc
		do sed -e 's:\.conkyweatherrc:mire-weather:g' -i mire/$fle || die "eek!"; done
		sed -e 's:| \${color} Arch-pkg*conky-updates.pl}  |::g' -i mire/conkyrc || die "eek!"
		insinto /usr/share/conky/themes
		doins -r mire
	}
	use pekwm && {
		for theme in Mirev2-{blue,grey,lime,orange,pink}
		do mv ${theme} ${theme/Mirev2-/mire-}; done
		insinto /usr/share/pekwm/themes
		doins -r mire-* || die "eek!"
		rm -r mire-*
		use axonkolor && {
			insinto /usr/share/fonts/TTF
			doins stan0755.ttf || die "eek!"
			insinto /usr/share/pekwm/themes
			mv AXONKOLOR axonkolor
			doins -r axonkolor || die "eek!"
		}
	}
	mv Mire\ v2/Mire{v2_,\ v2\ }Grey.emerald
	for theme in Blue Grey Lime Orange Pink; do
		tar xf Mire\ v2/Mire\ v2_${theme}-gtk2.tar.gz || die "eek!"
		mv Mire\ v2_${theme} mire-${theme,} || die "eek!"
		use emerald && mv Mire\ v2/Mire\ v2\ ${theme}.emerald \
			mire-${theme,}/mire-${theme,}.emerald
		mv Mire\ v2/start_${theme,}.png mire-${theme,}/start-here_mire-${theme,}.png
		use fluxbox && {
			mkdir -p styles/mire-${theme,}
			mv Mire\ v2/Mirev2_${theme}/* styles/mire-${theme,}/
		}
		use openbox && mv Mire\ v2/Mire\ v2_${theme,}/* mire-${theme,}/
	done
	insinto /usr/share/themes
	doins -r mire-* || die "eek!"
	use fluxbox && {
		insinto /usr/share/fluxbox
		doins -r styles || die "eek!"
	}
}
