# Copyright 2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/deadbeef/deadbeef-9999.ebuild,v 1.6 2016/06/06 19:57:55 Exp $

EAPI=5
PLOCALES="be bg bn ca cs da de el en_GB eo es et fa fi fr gl he hr hu id it ja kk km
lg lt nb nl pl pt pt_BR ro ru si sk sl sr sr@latin sv te tr ug uk vi zh_CN zh_TW"

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/Alexey-Yakovenko/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		AUTOTOOLS_AUTORECONF=1
		;;
	(*)
		KEYWORDS="~amd64 ~x86"
		VCS_ECLASS=vcs-snapshot
		SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
		;;
esac
inherit l10n fdo-mime gnome2-utils flag-o-matic autotools-utils ${VCS_ECLASS}

DESCRIPTION="DeaDBeeF - Ultimate Music Player For GNU/Linux"
HOMEPAGE="http://deadbeef.sourceforge.net/"
LICENSE="|| ( GPL-2 LGPL-2.1 )"

SLOT="0"
IUSE="+aac adplug alac +alsa +artwork +cdda +curl dts dumb ffmpeg +flac gme gtk 
gtk3 lastfm libnotify libsamplerate +mad +mac sid sndfile +wavpack musepack midi 
mms +nls oss pulseaudio +nptl sndfile static +twolame aosdk pth shn tta +vorbis
vtx +X zip imlib"

REQUIRED_USE="lastfm? ( curl )
	imlib? ( curl )
	?? ( gtk gtk3 )
	?? ( nptl pth )"

GTK_DEPEND="dev-libs/jansson
	 x11-libs/gtkglext"
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
	twolame? ( media-sound/twolame )
	curl? ( >=net-misc/curl-7.10 )
	cdda? ( dev-libs/libcdio media-libs/libcddb )
	gtk? ( >=x11-libs/gtk+-2.12:2
		${GTK_DEPEND} )
	gtk3? ( x11-libs/gtk+:3
		${GTK_DEPEND} )
	X? ( x11-libs/libX11 
		|| ( x11-libs/libSM x11-libs/libICE ) )
	pulseaudio? ( media-sound/pulseaudio )
	imlib? ( media-libs/imlib2 )
	!imlib? ( virtual/jpeg media-libs/libpng )
	libsamplerate? ( media-libs/libsamplerate )
	musepack? ( media-sound/musepack-tools )
	aac? ( media-libs/faad2 )
	alac? ( media-libs/faad2 )
	libnotify? ( virtual/notification-daemon sys-apps/dbus )
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
	nls? ( virtual/libintl )
	oss? ( virtual/libc )"

AUTOTOOLS_PRUNE_LIBTOOL_FILES=all

pkg_setup() {
	local LINGUAS
	use nls && LINGUAS="$(l10n_get_locales)"
	export LINGUAS
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		--enable-threads=$(usex nptl posix $(usex pth pth))
		$(use_enable alsa)
		$(use_enable oss)
		$(use_enable pulseaudio pulse)
		$(use_enable gtk gtk2)
		$(use_enable gtk3 gtk3)
		$(use_enable curl vfs-curl)
		$(use_enable lastfm lfm)
		$(use_enable artwork artwork)
		$(use_enable imlib artwork_imlib2)
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
		$(use_enable aosdk psf)
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
	for l in LGPLv2.1 GPLv2; do
		rm -f "${D}"/usr/share/doc/${PF}/COPYING.${l}
		dosym "${PORTDIR}"/licenses/${l/v/-} /usr/share/doc/${PF}/COPYING.${l}
	done
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

