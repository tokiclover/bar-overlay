# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/media-plugins/tap-plugins-9999,v 1.1 2011/12/22 -tclover [topic #719273] Exp $

inherit cvs

DESCRIPTION="Tom's Audio Processing LADSPA plugins"
HOMEPAGE="http://tap-plugins.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

ECVS_SERVER="${PN}.cvs.sourceforge.net:/cvsroot/${PN}"
ECVS_MODULE="${PN}"
S="${WORKDIR}/${ECVS_MODULE}"

src_unpack() {
	cvs_src_unpack
	cd "${S}"
	sed	-e 's:/usr/local:\${D}/usr:g' -i Makefile || die "eek!"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CREDITS README
}
