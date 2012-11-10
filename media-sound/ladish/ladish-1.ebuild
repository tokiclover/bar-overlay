# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-sound/ladish/ladish-1.ebuild,v 1.0 2012/11/09 12:42:09 -tclover Exp $

EAPI=2

inherit eutils

DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="http://ladish.org/"
SRC_URI="http://ladish.org/download/ladish-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lash"

RDEPEND="media-sound/jack-audio-connection-kit[dbus]
	>=x11-libs/flowcanvas-0.6.4
	sys-apps/dbus
	>dev-libs/glib-2.20.3
	>x11-libs/gtk+-2.20.0
	>gnome-base/libglade-2.6.2
	>dev-libs/dbus-glib-0.74
	dev-lang/python"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	local myconf="--prefix=/usr --destdir=${D}"
	use lash && myconf="${myconf} --enable-liblash"

	einfo "Running \"./waf configure ${myconf}\" ..."
	./waf configure ${myconf} || die "waf configure failed"
	./waf || die "failed to build"
}

src_install() {
	./waf --destdir="${D}" install || die "install failed"
	dodoc AUTHORS README NEWS
	use lash &&	dosym /usr/include/{lash,lash-1.0/lash}
 
}
