# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

EAPI=3

DESCRIPTION="LV2 Dynamic extension API"
HOMEPAGE="http://lv2plug.in/trac/"
SRC_URI="http://lv2plug.in/spec/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=media-libs/lv2core-2.0"

S="${WORKDIR}/dyn-manifest.lv2"

src_prepare() {
	epatch "$FILESDIR"/makefile.patch
}
