# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/x11-themes/faenza-icon-theme-lo-0.9.2_pre20110614,v 1.1 2011/07/25 -tclover Exp $

EAPI=3

DESCRIPTION="An unfinished port of the pretty Faenza icon theme to LibreOffice 3.4."
HOMEPAGE="http://kadu20es.deviantart.com/art/Faenza-4-LibreOffice-3-4-213121128"
SRC_URI="${DISTDIR}/${P}.zip
		mod? ( ${DISTDIR}/${PN}-mod-0.3.zip )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="mod"

DEPEND="app-arch/unzip"
RDEPEND="|| ( >=app-office/libreoffice-3.3.0 >=app-office/libreoffice-bin-3.3.0 )"

src_install() {
	insinto /usr/lib64/libreoffice/basis3.4/share/config
	mv "${DISTDIR}"/${P}.zip images_faenza.zip
	use mod && mv ${DISTDIR}/${PN}-mod-0.3.zip images_faenza-mod.zip
	doins images_faenza.zip || die "eek!"
	use mod && doins images_faenza-mod.zip || die "eek!"
}
