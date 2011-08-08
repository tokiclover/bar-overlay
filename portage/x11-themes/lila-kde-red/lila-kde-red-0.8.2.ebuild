# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Lila icons for KDE (red version)"
HOMEPAGE="http://lila-theme.berlios.de"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RESTRICT="nomirror nostrip"
SRC_URI="http://download.berlios.de/lila-theme/${P}.tar.bz2"

BASEDIR="/usr/share/icons/${PN}/"
src_install() {
        dodir ${BASEDIR}
        cp -R ${WORKDIR}/${PN}/* ${D}/${BASEDIR}
}

