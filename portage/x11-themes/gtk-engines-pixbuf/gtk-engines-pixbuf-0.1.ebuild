# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Gtk pixbuf engine patched to support real transparency for
insensitive (disabled) images on buttons, menus, etc."
HOMEPAGE="http://gnome-look.org/content/show.php/gtk2-engine-pixbuf+%28Patched%29?content=77783"
SRC_URI="${DISTDIR}/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux
~x86-linux"
IUSE="+themes"

RDEPEND=">=x11-libs/gtk+-2.12"
DEPEND="${RDEPEND}
    >=dev-util/intltool-0.37.1
	sys-devel/gettext
    dev-util/pkgconfig"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	cd "${WORKDIR}"/*
	econf ./configure --prefix=/usr
}

src_compile() {
	cd "${WORKDIR}"/*
	emake
}

src_install() {
	cd "${WORKDIR}"/*
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README NEWS TODO.tasks
}
