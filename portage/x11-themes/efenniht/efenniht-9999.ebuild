# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/x11-themes/efenniht-9999.ebuild, v1.2 2011/08/17 Exp $

ESVN_REPO_URI="http://svn.enlightenment.org/svn/e/trunk/THEMES/efenniht"
inherit subversion

DESCRIPTION="An EFL theme derived from equinox..."
RDEPEND="x11-wm/enlightenment"
DEPEND="dev-util/pkgconfig"
IUSE="gtk"
EGTK=efenniht-gtk2-0.1.tar.gz
SRC_URI=" gtk? ( http://gnome-look.org/CONTENT/content-files/142710-Efenniht-gtk2.tar.gz -> ${EGTK} )"
EAPI=2
WANT_AUTOTOOLS=no
ESVN_PROJECT=enlightenment/THEMES
SLOT=0

src_unpack() {
	use gtk && unpack ${EGTK} || die "eek!"
	subversion_src_unpack
	export ESVN_REPO_URI=${ESVN_REPO_URI/THEMES\/${PN}/elementary}
	export ESVN_PROJECT=${ESVN_PROJECT/THEMES}
	mv ${WORKDIR}/efennih{t,}-${PV} || die "eek!"
	subversion_src_unpack
	mv ${WORKDIR}/{efenniht,elementary}-${PV}
	mv ${WORKDIR}/efennih{,t}-${PV}
}

src_compile() {
	sed	-e "s:\.\./elementary:elementary-${PV}:g" -i Makefile || die "eek!"
	emake all || die "eek!"
}

src_install() {
	sed -e "s:elementary/data:elementary:" \
		-e "s:\$(shell :\$(DESTDIR)\$(:" -i Makefile || die "eek!"
	emake DESTDIR="${D}" install-system || die "eek!"
	if use gtk; then
		mv ../{E,e}fenniht-gtk2 || die "eek!"
		insinto /usr/share/themes
		doins -r ../efenniht-gtk2 || die "eek!"
	fi
}
