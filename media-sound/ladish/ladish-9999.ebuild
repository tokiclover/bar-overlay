# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-sound/ladish/ladish-9999.ebuild,v 1.0 2012/11/12 12:14:23 -tclover Exp $

EAPI=5

inherit eutils git-2

DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="http://ladish.org/"
EGIT_REPO_URI="git://repo.or.cz/ladish.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc gtk lash nls python"
REQUIRED_USE="python? ( lash )"

LANGS="de fr ru"

for l in ${LANGS}; do
	IUSE+=" linguas_${l}"
done

RDEPEND="media-sound/jack-audio-connection-kit[alsa,dbus]
	gtk? ( 
		dev-libs/boost
		dev-libs/expat
		>=x11-libs/gtk+-2.20.0:2
		>=x11-libs/flowcanvas-0.6.4
		>=dev-libs/glib-2.20.3
		>=dev-libs/dbus-glib-0.74 )
	>=gnome-base/libglade-2.6.2
	dev-lang/python"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	dev-util/intltool
	dev-libs/ossp-uuid"

src_prepare() {
	epatch "${FILESDIR}"/lash-1.0.pc.in.patch
	
	if use nls; then
		local linguas
		for l in ${LINGUAS}; do
			has ${l} ${LANG} && linguas+=" ${l}"
		done
		for l in ${LANGS}; do
			use linguas_${l} &&
				if has ${l} ${linguas}; then :;
				else linguas+=" ${l}"; fi
		done
		echo "${linguas}" > po/LINGUAS
	else echo > po/LINGUAS; fi
}

src_configure() {
	local myconf="--prefix=/usr --destdir=\"${D}\" \
		$(use debug && echo '--debug') \
		$(use && doc echo '--doxygen') \
		$(use_enable lash liblash) \
		$(use_enable python pylash)"

	einfo "Running \"./waf configure ${myconf}\" ..."
	./waf configure ${myconf} || die
}

src_compile() {
	./waf || die "failed to build"
}

src_install() {
	./waf --destdir="${D}" install || die
	dodoc AUTHORS README NEWS
	use lash &&	dosym /usr/include/{lash,lash-1.0/lash}
}
