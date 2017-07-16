# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: x11-misc/netwmpager/netwmpager-2.04.ebuild,v 1.4 2014/07/31 15:08:29 Exp $

EAPI=5

inherit base toolchain-funcs

DESCRIPTION="EWMH (NetWM) compatible pager. Works with Openbox and other EWMH
compliant window managers."
HOMEPAGE="http://sourceforge.net/projects/sf-xpaint/files/netwmpager/"
SRC_URI="mirror://sourceforge/sf-xpaint/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXft
	x11-libs/libXdmcp
	x11-libs/libXau"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto"

DOCS=( README )

PATCHES=(
	"${FILESDIR}"/${P}-libX11.patch
)

src_configure() {
	# econf doesn't work
	tc-export CC
	./configure --prefix=/usr || die
}
