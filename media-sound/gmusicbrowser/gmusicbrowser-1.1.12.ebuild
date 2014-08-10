# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/gmusicbrowser/gmusicbrowser-1.1.12.ebuild,v 1.5 2014/08/08 09:12:46 -tclover Exp $

EAPI=5

PLOCALES="cs de es fr hu it ko nl pl pt pt_BR ru sv zh_CN"

inherit fdo-mime

DESCRIPTION="An open-source jukebox for large collections of mp3/ogg/flac files"
HOMEPAGE="http://gmusicbrowser.org/"
SRC_URI="http://${PN}.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="123 a52 aac +alsa cdparanoia +dbus doc dts faad flac gstreamer jack lame
mac mad modplug musepack mplayer +nls libnotify ogg oss oss4 pulseaudio gsm 
sid titlebar trayicon twolame vorbis wavpack webkit"
REQUIRED_USE="|| ( 123 mplayer gstreamer )"

DEPEND=">=dev-lang/perl-5.8
	dev-vcs/git
	nls? ( sys-devel/gettext )"

RDEPEND="dev-perl/gtk2-perl
	dbus? ( dev-perl/Net-DBus )
	libnotify? ( dev-perl/Gtk2-Notify )
	titlebar? ( dev-perl/gnome2-wnck )
	trayicon? ( dev-perl/gtk2-trayicon )
	gstreamer? (
		dev-perl/GStreamer
		dev-perl/GStreamer-Interfaces
		media-plugins/gst-plugins-meta:0.10[a52?,aac?,alsa?,dts?,faad?,flac?,jack?,lame?,ogg?,pulseaudio?,vorbis?,wavpack?]
		oss4? ( media-plugins/gst-plugins-oss4:0.10 )
		mac? ( media-libs/gst-plugins-good:0.10 )
		cdparanoia? ( media-plugins/gst-plugins-cdparanoia:0.10 )
		gsm? ( media-plugins/gst-plugins-gsm:0.10 )
		mad? ( media-plugins/gst-plugins-mad:0.10 )
		modplug? ( media-plugins/gst-plugins-modplug:0.10 )
		musepack? ( media-plugins/gst-plugins-musepack:0.10 )
		sid? ( media-plugins/gst-plugins-sidplay:0.10 )
	)
	mplayer? ( || (
	   media-video/mplayer[a52?,alsa?,dts?,faad?,jack?,mad?,oss?,pulseaudio?,twolame?,vorbis?]
	   media-video/mplayer2[a52?,alsa?,dts?,faad?,jack?,mad?,oss?,pulseaudio?,vorbis?]
	   media-video/mpv[alsa?,jack?,oss?,pulseaudio?]
	   )
	)
	123? (
		|| ( media-sound/mpg321 media-sound/mpg123 )
		ogg? ( media-sound/vorbis-tools[flac?,nls?,ogg123] )
		flac? ( media-sound/flac123 )
		vorbis? ( media-sound/vorbis-tools[flac?,nls?,ogg123] )
		alsa? ( media-sound/alsa-utils )
	)
	webkit? ( dev-perl/perl-WebKit-GTk )"

src_prepare() {
	sed -e '/menudir/d' -e '/^LINGUAS.*$/d' -i Makefile || die
	export LINGUAS="$(l10n_get_locales)"
}

src_install() {
	emake \
		DOCS="AUTHORS NEWS README" \
		DESTDIR="${D}" \
		LINGUAS="${linguas}" \
		iconsdir="${D}/usr/share/icons/hicolor/32x32/apps" \
		liconsdir="${D}/usr/share/icons/hicolor/48x48/apps" \
		miconsdir="${D}/usr/share/pixmaps" \
		install

	use doc && dohtml layout_doc.html
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
