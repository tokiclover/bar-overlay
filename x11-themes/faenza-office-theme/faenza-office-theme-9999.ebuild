# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-themes/faenza-office-theme/faenza-office-theme-9999.ebuild,v 1.1 2012/05/08 -tclover Exp $

EAPI=2

inherit git

DESCRIPTION="An unfinished port of the pretty Faenza icon theme to {Libre,Open}Office"
HOMEPAGE="https://github.com/tokiclover/faenza-office"
EGIT_REPO_URI="https://github.com/tokiclover/faenza-office.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="mod"

DEPEND=""
RDEPEND="|| ( >=app-office/libreoffice-3.3.0 >=app-office/libreoffice-bin-3.3.0 )"

S="${WORKDIR}"

src_install() {
	if use mod; then ./build.sh all || die "eek!"
	else ./build.sh fae || die "eek!"; fi
	insinto /usr/lib64/libreoffice/basis3.4/share/config
	if use mod; then doins images_faenza-mod.zip || die "eek!"; fi
	doins images_faenza.zip || die "eek!"
}
