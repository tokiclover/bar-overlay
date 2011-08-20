# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/x11-themes/efenniht-9999.ebuild, v1.2 2011/08/17 Exp $

ESVN_SUB_PROJECT="THEMES"
inherit enlightenment

DESCRIPTION="An EFL theme derived from equinox..."
RDEPEND="x11-wm/enlightenment"
DEPEND="dev-util/pkgconfig"
IUSE="gtk"
EGTK=efenniht-gtk2-0.1.tar.gz
SRC_URI=" gtk? ( http://gnome-look.org/CONTENT/content-files/142710-Efenniht-gtk2.tar.gz -> ${EGTK} )"
EAPI=2

src_unpack() {
	use gtk && unpack ${EGTK} || die "eek!"
	subversion_src_unpack
	export ESVN_REPO_URI=${ESVN_SERVER:-${E_LIVE_SERVER_DEFAULT_SVN}}/elementary
	unset ESVN_SUB_PROJECT && export ESVN_PROJECT=${ESVN_PROJECT/THEMES}
	mv ${WORKDIR}/efennih{t,} || die "eek!"
	subversion_src_unpack
	mv ${WORKDIR}/{efenniht,elementary}
	mv ${WORKDIR}/efennih{,t}
}

src_compile() {
	sed	-e "s:../elem:elem:g" -i Makefile || die "eek!"
	emake all || die "eek!"
}

src_install() {
	sed	-e "s:\$(.*prefix .*):${D}/usr:g" \
		-e "s:shaelem:share/elem:g" -i Makefile || die "eek!"
	emake install-system || die "eek!"
	if use gtk; then
		insinto /usr/share/themes
		doins -r ../Efenniht-gtk2 || die "eek!"
	fi
}
