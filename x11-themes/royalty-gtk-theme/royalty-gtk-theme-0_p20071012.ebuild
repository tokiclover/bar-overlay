# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/royalty-gtk-theme/royalty-gtk-theme-0_p20071012.ebuild,v 1.1 2012/07/04 00:22:12 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="A port of the popular Mire v2 suite for Windows with 5 colour 
schemes, blue, lime, orange, pink and grey"
HOMEPAGE="http://gnome-look.org/content/show.php/MurrinaMire+v2+themepack?content=51023"
SRC_URI="http://www.deviantart.com/download/67293584/Royalty_GTK_by_thrynk.zip -> ${P}.zip
	fluxbox? ( http://www.deviantart.com/download/67293908/Royalty_for_Fluxbox_by_thrynk.zip
			  -> ${P/gtk/fluxbox}.zip )
	emerald? ( http://www.deviantart.com/download/68074473/Royalty_Emerald_by_thrynk.emerald
			   -> ${PN/gtk/emerald}-0_p20071023.emerald )
	conky?   ( http://gnome-look.org/CONTENT/content-files/52896-conky.tar.gz
			  -> ${PN/gtk/conky}-0.3.tar.gz )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="conky emerald fluxbox minimal"
EAPI=2

RDEPEND="minimal? ( !x11-themes/gnome-theme )
		fluxbox? ( x11-wm/fluxbox )
		x11-themes/gtk-engines-xfce
		conky?    ( app-admin/conky )
"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	if use conky; then
		mv conky/{ReadMe,README}
		mv conky/{arch-updates/,}conky-updates.pl; rm -r conky/arch-updates; mv conky/{.,}conkyrc
		mv conky/{.conkyrc_gmail,conkygmailrc}; mv conky/{.conkyweatherrc,royalty-weather}
		for fle in conky{,gmail}rc
		do sed -e 's:\.conkyweatherrc:royalty-weather:g' -i conky/$fle || die "eek!"; done
		sed -e 's:| \${color} Arch-pkg*conky-updates.pl}  |::g' -i conky/conkyrc || die "eek!"
		insinto /usr/share/conky/themes
		doins -r conky
		mv "${D}"/usr/share/conky/themes/{conky,royalty} || die "eek!"
	fi
	if use emerald; then
		cp "${DISTDIR}"/${PN/gtk/emerald}-0_p20071023.emerald \
			royalty/royalty.emerald || die "eek!"
	fi
	if use fluxbox; then
		insinto /usr/share/fluxbox/royalty
		doins -r royalty/{pixmaps,theme.cfg} || die "eek!"
	fi
	rm -rf royalty/{pixmaps,theme.cfg}
	insinto /usr/share/themes
	doins -r royalty || die "eek!"
}
