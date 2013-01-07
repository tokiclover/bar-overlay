# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-plugins/deadbeef-plugins-infobar/deadbeef-plugins-infobar-1.3.ebuild,v 1.0 2012/11/08 07:56:50 -tclover Exp $

EAPI=5

inherit eutils 

DESCRIPTION="A plugin that allows you to view lyrics, biography, list of similar artists"
HOMEPAGE="https://bitbucket.org/dsimbiriatin/deadbeef-infobar/wiki/Home"
SRC_URI="https://bitbucket.org/dsimbiriatin/${PN/-plugins}/downloads/${P/-plugins}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk gtk3"
REQUIRED_USE="|| ( gtk gtk3 )"

DEPEND="dev-libs/libxml2 gtk? ( x11-libs/gtk+:2 ) gtk3? ( x11-libs/gtk+:3 )"
RDEPEND="media-sound/deadbeef ${DEPEND}"

S="${WORKDIR}"/${P/-plugins}

src_compile() {
	use gtk && emake gtk2
	use gtk3 && emake gtk3
}

src_install() {
	insinto /usr/$(get_libdir)/deadbeef
	doins gtk*/ddb_infobar_gtk*.so
}
