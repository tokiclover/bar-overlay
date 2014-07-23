# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-themes/awoken-icon-theme/awoken-icon-theme-2.5.ebuild,v 1.3 2014/07/20 00:21:46 -tclover Exp $

EAPI="5"

inherit gnome2-utils

MY_PN=AwOken
DESCRIPTION="A great monochrome-ish scalable icon theme with 100³ colors and more"
HOMEPAGE="http://alecive.deviantart.com/"
SRC_URI="https://dl.dropbox.com/u/8029324/${MY_PN}-${PV}.zip -> ${P}.zip"

LICENSE="CC BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="colorization -minimal"

RDEPEND="minimal? ( !x11-themes/gnome-icon-theme )
	colorization? ( media-gfx/imagemagick )"
DEPEND="${DEPEND}"

RESTRICT="binchecks strip"

src_unpack() {
	unpack ${A}
	mv ${MY_PN}-${PV} ${P} || die
	pushd "${S}" > /dev/null 2>&1
	for theme in ${MY_PN}{,Dark,White}
		do unpack ./$theme.tar.gz
		mv $theme $(echo "$theme" | sed 's/\([A-Z]\)/\L\1/g')
	done
	popd > /dev/null 2>&1
}

src_prepare() {
	local res x name=awoken
	for x in ${name}{,dark,white}; do
		for res in 24 128; do
			cd "${x}"/clear/${res}x${res}/places/
			ln -s -f ../start-here/start-here-gentoo1.png start-here.png || die
			ln -s -f ../start-here/start-here-gentoo1.png start-here-symbolic.png || die
			cd "${S}"
		done
	done
	rm ${name}{,dark,white}/${PN}-* || die
	find . -iname '.sh' -exec rm '{}' +

}

src_install() {
	insinto /usr/share/icons
	doins -r awoken{,dark,white}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
