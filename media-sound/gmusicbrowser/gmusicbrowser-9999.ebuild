# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-sound/gmusicbrowser/gmusicbrowser-9999.ebuild,v 1.3 2012/09/29 09:11:11 -tclover Exp $

EAPI=5

inherit fdo-mime git-2

DESCRIPTION="An open-source jukebox for large collections of mp3/ogg/flac files"
HOMEPAGE="http://squentin.free.fr/gmusicbrowser/gmusicbrowser.html"
EGIT_REPO_URI="git://github.com/squentin/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="a52 aac +alsa cdparanoia +dbus doc dts +faad +flac +gstreamer jack +lame
+mac mad modplug +musepack mplayer +nls libnotify +ogg oss oss4 pulseaudio gsm 
sid titlebar trayicon +twolame vorbis +wavpack webkit"

LANGS="cs de es fr hu it ko nl pl pt pt_BR ru sv zh_CN"
for l in ${LANGS}; do
	IUSE+=" linguas_${l}"
done

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
		media-libs/gst-plugins-base:0.10
		alsa? ( media-plugins/gst-plugins-alsa:0.10 )
		jack? ( media-plugins/gst-plugins-jack:0.10 )
		oss? ( media-plugins/gst-plugins-oss:0.10 )
		oss4? ( media-plugins/gst-plugins-oss4:0.10 )
		pulseaudio? ( media-plugins/gst-plugins-pulse:0.10 )
		a52? ( media-plugins/gst-plugins-a52dec:0.10 )
		mac? ( media-libs/gst-plugins-good:0.10 )
		cdparanoia? ( media-plugins/gst-plugins-cdparanoia:0.10 )
		dts? ( media-plugins/gst-plugins-dts:0.10 )
		faad? ( media-plugins/gst-plugins-faad:0.10 )
		flac? ( media-plugins/gst-plugins-flac:0.10
				media-libs/gst-plugins-good:0.10 )
		lame? ( media-plugins/gst-plugins-lame:0.10 )
		gsm? ( media-plugins/gst-plugins-gsm:0.10 )
		mad? ( media-plugins/gst-plugins-mad:0.10 )
		modplug? ( media-plugins/gst-plugins-modplug:0.10 )
		musepack? ( media-plugins/gst-plugins-musepack:0.10 )
		ogg? ( media-plugins/gst-plugins-ogg:0.10 )
		sid? ( media-plugins/gst-plugins-sidplay:0.10 )
		vorbis? ( media-plugins/gst-plugins-vorbis:0.10 )
		wavpack? ( media-plugins/gst-plugins-wavpack:0.10 )
	)
	mplayer? ( || (
	   media-video/mplayer[a52?,alsa?,dts?,faad?,jack?,mad?,oss?,pulseaudio?,twolame?,vorbis?]
	   media-video/mplayer2[a52?,alsa?,dts?,faad?,jack?,mad?,oss?,pulseaudio?,vorbis?] )
	)
	!gstreamer? (
		!mplayer? (
			|| ( 
				media-sound/mpg321[alsa?] media-sound/mpg123[alsa?,jack?,oss?,pulseaudio?]
			)
			ogg? ( media-sound/vorbis-tools[flac?,nls?,ogg123] )
			flac? ( media-sound/flac123 )
			vorbis? ( media-sound/vorbis-tools[flac?,nls?,ogg123] )
		)
	)
	webkit? ( dev-perl/perl-WebKit-GTk )"

src_prepare() {
	sed -e '/menudir/d' -e '/^LINGUAS.*$/d' -i Makefile || die
}

src_install() {
	local l LINGUAS
	if use nls; then
		for l in ${LANGS}; do
			if use linguas_${l}; then
				LINGUAS+=" ${l}"
			fi
		done
	else LINGUAS=""; fi

	emake \
		DOCS="AUTHORS NEWS README" \
		DESTDIR="${D}" \
		LINGUAS="${linguas}" \
		iconsdir="${D}/usr/share/pixmaps" \
		install

	use doc && dohtml layout_doc.html
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
