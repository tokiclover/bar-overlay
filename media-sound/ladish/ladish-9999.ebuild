# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-sound/ladish/ladish-9999.ebuild,v 1.0 2012/11/09 12:42:13 -tclover Exp $

EAPI=2

inherit git

DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="http://ladish.org/"
EGIT_REPO_URI="git://repo.or.cz/ladish.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="lash"

RDEPEND="media-sound/jack-audio-connection-kit[dbus]
	>=x11-libs/flowcanvas-0.6.4
	>dev-libs/glib-2.20.3
	>=x11-libs/gtk+-2.20.0
	>gnome-base/libglade-2.6.2
	>dev-libs/dbus-glib-0.74
	dev-lang/python"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	git_src_unpack
	cd "${S}"
}

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
