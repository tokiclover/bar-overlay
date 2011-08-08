# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="X11 Mouse Cursor plug-in for GIMP (or gimp-xmc-plugin) enable GIMP to import,
export X11 mouse cursor"
HOMEPAGE="http://gimpstuff.org/content/show.php/X11+Mouse+Cursor+%28XMC%29+plug-in?content=94503"
SRC_URI="${DISTDIR}/${P}.tar.gz"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gimp xmc gtk2"

DEPEND=">=media-gfx/gimp-2.5.0
		>=x11-libs/libXcursor-1.1.0
		>=sys-libs/glibc-2.1.0
		>=dev-libs/glib-2.28.0"
RDEPEND="${DEPEND}"

src_configure() {
	econf ./configure --prefix=/usr 
}

src_compile() {	
	emake
}

src_install() {
	emake install DESTDIR="${D}"
}

