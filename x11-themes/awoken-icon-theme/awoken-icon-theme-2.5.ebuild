# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-themes/awoken-icon-theme/awoken-icon-theme-2.5.ebuild,v 1.4 2015/06/24 00:21:46 -tclover Exp $

EAPI=5

inherit gnome2-utils

MY_PN=AwOken
DESCRIPTION="Monochrome/color-ish scalable icon theme with colorization"
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

src_unpack()
{
	local name
	unpack ${A}
	mv ${MY_PN}-${PV} ${P} || die
	pushd "${S}" > /dev/null 2>&1
	cp -p "${FILESDIR}"/awoken-icon-settings.sh . || die
	for theme in ${MY_PN}{,Dark,White}; do
		unpack ./${theme}.tar.gz
		if [ -f "${theme}/.${theme}rc" ]; then
			mv "${theme}/.${theme}rc" "${theme}/${theme}rc"
		fi
	done
	popd > /dev/null 2>&1
}
src_prepare()
{
	local res x

	for x in ${MY_PN}{,Dark,White}; do
		ICONSET="${x}"
		AWOKEN_RCFILE="${S}/${x}/${x}rc"
		LOCALDIR="${S}/${x}"
		ICONSDIR="${LOCALDIR}"
		export ICONSET ICONSDIR LOCALDIR AWOKEN_RCFILE
		bash "${S}"/awoken-icon-settings.sh -Fawoken -fawokenclear

		for res in 24 128; do
			pushd "${x}"/clear/${res}x${res}/places > /dev/null 2>&1
			ln -s -f ../start-here/start-here-gentoo1.png start-here.png
			ln -s -f ../start-here/start-here-gentoo1.png start-here-symbolic.png
			popd > /dev/null 2>&1
		done
	done
	unset ICONSET ICONSDIR LOCALDIR AWOKEN_RCFILE
	rm ${MY_PN}{,Dark,White}/${PN}-* || die
	rm ${MY_PN}*/extra/*.sh
	mv ${MY_PN}/Installation_and_Instructions.pdf README.pdf || die
}

src_install()
{
	local dir=/usr/share/icons
	insinto "${dir}"
	doins -r ${MY_PN}{,Dark,White}
	exeinto ${dir}/${MY_PN}
	doexe awoken-icon-settings.sh
	dodoc README.pdf
}

pkg_preinst()
{
	gnome2_icon_savelist
}
pkg_postinst()
{
	gnome2_icon_cache_update
}
pkg_postrm()
{
	gnome2_icon_cache_update
}
