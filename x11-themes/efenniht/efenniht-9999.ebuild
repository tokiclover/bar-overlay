# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/efenniht/efenniht-9999.ebuild,v 1.1 2012/11/06 00:19:45 -tclover Exp $

EAPI=2

ESVN_SUB_PROJECT="THEMES"
inherit enlightenment

DESCRIPTION="An EFL theme derived from equinox..."
RDEPEND="x11-wm/enlightenment"
DEPEND="dev-util/pkgconfig media-libs/edje"

IUSE="gtk"
EGTK=efenniht-gtk2-0.1.tar.gz
SRC_URI=" gtk? ( http://gnome-look.org/CONTENT/content-files/142710-Efenniht-gtk2.tar.gz -> ${EGTK} )"
SLOT=0

WANT_AUTOTOOLS=no

src_unpack() {
	use gtk && unpack ${EGTK} || die
	subversion_src_unpack
	export ESVN_REPO_URI=${ESVN_REPO_URI/THEMES\/${PN}/elementary}
	export ESVN_PROJECT=${ESVN_PROJECT/THEMES}
	mv ${WORKDIR}/efenniht{,-${PV}} || die
	subversion_src_unpack
	mv ${WORKDIR}/{efenniht,elementary}
	mv ${WORKDIR}/efenniht{-${PV},}
}

src_configure() { :; }
src_compile() {
	sed -e 's,\.\./\.\./elem,\.\./elem,g' -i Makefile || die
	emake all || die
}

src_install() {
	insinto /usr/share/enlightenment/data/themes
	doins efenniht.edj
	insinto /usr/share/elementary/themes
	doins elm-efenniht.edj
	if use gtk; then
		mv {../Efenniht-gtk2,efenniht}
		insinto /usr/share/themes
		doins -r efenniht || die
	fi
}
