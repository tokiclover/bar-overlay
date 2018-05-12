# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome2-utils

MY_PN=kAwOken
DESCRIPTION="KDE port of monochrome/color-ish scalable icon theme with colorization"
HOMEPAGE="https://alecive.deviantart.com/art/"
SRC_URI="https://dl.dropbox.com/u/8029324/${MY_PN}-${PV}.zip -> ${P}.zip"

LICENSE="CC-BY-NC-SA-3.0 CC-BY-NC-ND-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-minimal"

RDEPEND="minimal? ( !kde-base/oxygen-icons )"
DEPEND="app-arch/unzip"

RESTRICT="binchecks strip"

src_unpack()
{
	local name
	unpack "${A}"
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
	gnome2_icon_savelis
}
pkg_postinst()
{
	gnome2_icon_cache_update
}
pkg_postrm()
{
	gnome2_icon_cache_update
}
