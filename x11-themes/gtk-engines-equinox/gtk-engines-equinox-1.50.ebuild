# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/x11-themes/gtk-engines-equinox-1.50,v 1.1 2012/05/05 -tclover Exp $

EAPI="2"

inherit eutils gnome.org

DESCRIPTION="A heavily modified version of the beautiful Aurora engine"

HOMEPAGE="http://gnome-look.org/content/show.php/Equinox+GTK+Engine"
SRC_URI="http://gnome-look.org/CONTENT/content-files/121881-equinox-1.50.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.12"
PDEPEND=""
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.37.1
	sys-devel/gettext
	dev-util/pkgconfig"

S="${WORKDIR}"/${P##*-}

src_configure() {
	econf --prefix=/usr --libdir=/usr/$(get_libdir) --enable-animation
}

src_install() {
	emake DESTDIR="${D}" install || die "eek!"
	dodoc AUTHORS ChangeLog TODO
}
