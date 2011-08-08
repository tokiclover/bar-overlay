# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gmusicbrowser/gmusicbrowser-1.0.2.ebuild,v 1.1 2009/10/27 11:28:16 aballier Exp $

inherit fdo-mime

DESCRIPTION="An open-source jukebox for large collections of mp3/ogg/flac files"
HOMEPAGE="http://squentin.free.fr/gmusicbrowser/gmusicbrowser.html"
SRC_URI="http://gmusicbrowser.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="dbus gstreamer mplayer mozilla webkit"

RDEPEND=">=dev-lang/perl-5.8
	dev-perl/gtk2-perl
	dev-perl/gtk2-trayicon
	dev-perl/gnome2-wnck
	dbus? ( dev-perl/Net-DBus )
	gstreamer? (
		dev-perl/GStreamer
		dev-perl/GStreamer-Interfaces
		media-libs/gst-plugins-good
	)
	mplayer? ( || ( media-video/mplayer media-video/mplayer2 ) )
	!gstreamer? ( !mplayer? (
		media-sound/mpg123
		media-sound/mpg321
		media-sound/vorbis-tools
		media-sound/flac123
		media-sound/alsa-utils
	) )
	mozilla? ( dev-perl/Gtk2-MozEmbed )
	webkit? ( dev-perl/Gtk2-WebKit )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e 's:mpg321:mpg123:g' -i gmusicbrowser* || die "sed failed."
	patch -p1 -f < "${FILESDIR}"/gmusicbrowser_mplayer2.patch \
	|| die "patch failed."
}

src_install() {
		emake DOCS="AUTHORS NEWS README" DESTDIR="${D}" \
		iconsdir="${D}/usr/share/pixmaps" install \
		|| die "emake install failed."
	rm -rf "${D}"/usr/lib/menu/${PN}
	dohtml layout_doc.html
	prepalldocs
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
