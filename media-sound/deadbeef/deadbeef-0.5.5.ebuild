# Copyright 2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-sound/deadbeef/deadbeef-0.5.5.ebuild,v 1.2 2012/10/20 09:38:59 -tclover Exp $

EAPI="4"

inherit fdo-mime gnome2-utils flag-o-matic autotools-utils

DESCRIPTION="DeaDBeeF - Ultimate Music Player For GNU/Linux"
HOMEPAGE="http://deadbeef.sourceforge.net/"
LICENSE="GPL-2 LGPL-2.1"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+aac adplug +alac +alsa +artwork +cdda curl dts dumb ffmpeg +flac gme gnome gtk
gtk3 lastfm libnotify libsamplerate +mad +mac sid ndfile +wavpack +musepack midi mms
+nls oss pulseaudio threads sndfile static +psf pth shn +tta +vorbis vtx +X zip
artwork-imlib2"
REQUIRED_USE="lastfm? ( curl ) gnome? ( || ( gtk gtk3 ) ) static? ( !dumb !psf !shn )"

RDEPEND="adplug? ( media-libs/adplug )
	dts? ( media-libs/libdca )
	mac? ( media-sound/mac )
	gme? ( media-libs/game-music-emu )
	mms? ( media-libs/libmms )
	sid? ( media-sound/sidplay )
	tta? ( media-sound/ttaenc )
	midi? ( media-sound/wildmidi )
	alsa? ( media-libs/alsa-lib )
	mad? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	wavpack? ( media-sound/wavpack )
	sndfile? ( media-libs/libsndfile )
	curl? ( net-misc/curl )
	cdda? ( dev-libs/libcdio media-libs/libcddb )
	gtk? ( x11-libs/gtk+:2 x11-libs/gtkglext )
	gtk3? ( x11-libs/gtk+:3 x11-libs/gtkglext )
	X? ( x11-libs/libX11 )
	pulseaudio? ( media-sound/pulseaudio )
	artwork-imlib2? ( media-libs/imlib2 )
	libsamplerate? ( media-libs/libsamplerate )
	musepack? ( media-sound/musepack-tools )
	aac? ( media-libs/faad2 )
	alac? ( media-libs/faad2 )
	libnotify? ( x11-libs/libnotify sys-apps/dbus )
	zip? ( sys-libs/zlib dev-libs/libzip )
	pth? ( dev-libs/pth )
	gme? ( sys-libs/zlib )
	midi? ( media-sound/timidity-freepats )
	lastfm? ( net-misc/curl )
	dumb? ( media-libs/dumb )"

DEPEND=">=dev-lang/perl-5.8.1
	dev-perl/XML-Parser
	dev-lang/yasm
	ffmpeg? ( virtual/ffmpeg )
	nls? ( >=dev-util/intltool-0.40.0 )
	oss? ( virtual/libc )
	gnome? ( || ( x11-libs/libSM x11-libs/libICE ) )"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	sed -i "${S}"/plugins/wildmidi/wildmidiplug.c \
		-e 's,#define DEFAULT_TIMIDITY_CONFIG ",&/usr/share/timidity/freepats/timidity.cfg:,'
	autotools-utils_src_prepare
}

src_configure() {
	local thd=posix
	use pth && thd=pth
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable threads threads ${thd})
		$(use_enable alsa)
		$(use_enable oss)
		$(use_enable pulseaudio pulse)
		$(use_enable gtk gtk2)
		$(use_enable gtk3 gtk3)
		$(use_enable curl vfs-curl)
		$(use_enable lastfm lfm)
		$(use_enable artwork artwork)
		$(use_enable artwork-imlib2 artwork_imlib2)
		$(use_enable sid)
		$(use_enable mad mad)
		$(use_enable mac ffap)
		$(use_enable adplug)
		$(use_enable X hotkeys)
		$(use_enable vorbis)
		$(use_enable ffmpeg)
		$(use_enable flac)
		$(use_enable sndfile)
		$(use_enable wavpack)
		$(use_enable cdda )
		$(use_enable gme)
		$(use_enable libnotify notify)
		$(use_enable musepack)
		$(use_enable midi wildmidi)
		$(use_enable tta)
		$(use_enable dts dca)
		$(use_enable aac)
		$(use_enable mms)
		$(use_enable libsamplerate src)
		$(use_enable zip vfs_zip)
		$(use_enable alac)
		$(use_enable dumb dumb)
		$(use_enable psf)
		$(use_enable shn)
		$(use_enable static staticlink)
		$(use_enable vtx)
		--docdir="/usr/share/doc/${PF}"
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	docompress -x /usr/share/doc/${PF}
	remove_libtool_files all
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	if use gtk || use gtk3; then
		gnome2_icon_cache_update
	fi
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	if use gtk || use gtk3; then
		gnome2_icon_cache_update
	fi
}

