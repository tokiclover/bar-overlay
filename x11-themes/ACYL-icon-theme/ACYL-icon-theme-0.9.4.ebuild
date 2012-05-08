# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/ACYL-icon-theme/ACYL-icon-theme-0.9.4.ebuild,v 1.1 2012/05/08 -tclover Exp $

EAPI=2

inherit gnome2-utils

DESCRIPTION="A great monochrome-ish scalable icon theme with Any Color Ypu Like script"
HOMEPAGE="https://pobtott.deviantart.com"
SRC_URI="http://www.deviantart.com/download/175624910/any_color_you_like_by_pobtott-d2wk91q.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-minimal"

RDEPEND="minimal? ( !x11-themes/gnome-icon-theme )
		dev-lang/perl
		dev-python/gconf-python"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

MY_P=${P/-*-/_Icon_Theme_}
S="${WORKDIR}"

src_install() {
	unpack ./${MY_P}.tar.bz2
	mv ${MY_P} ${PN} || die "eek!"
	rm ${PN}/{GPL,*Instruction*,credit,changelog}
	insinto /usr/local/bin
	sed -e "s:\~/.icons/${MY_P}:/usr/share/icons/${PN}:g" -i ${PN}/AnyColorYouLike || die "eek!"
	install -pd "${D}"/usr/local/bin
	install -pm 755 ${PN}/AnyColorYouLike "${D}"/usr/local/bin || die "eek!"
	insinto /usr/share/icons
	doins -r ${PN} || die "eek!"
	chmod +x "${D}"/usr/share/icons/${PN}/scalable/scripts/script_* || die "eek!"
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { 
	#gnome2_icon_cache_update
	einfo
	einfo "one should create a icons grp and add oneself into it to be able to"
	einfo "modify colors and don't forget a \`chmod g+w -R /usr/share/icons/$PN"
	einfo
}
