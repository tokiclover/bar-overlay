# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/media-sound/ardour-3.9999.ebuild,v 1.1 2012/03/16 -tclover Exp $

EAPI="2"

inherit eutils toolchain-funcs fdo-mime flag-o-matic subversion versionator

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"

ESVN_REPO_URI="http://subversion.ardour.org/svn/ardour2/branches/3.0"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS=""
IUSE="altivec debug nls sse lv2 vst sys-libs tranzport wiimote"

RDEPEND="media-libs/liblo
	>=media-libs/taglib-1.5
	media-libs/aubio
	>=media-libs/liblrdf-0.4.0
	>=media-libs/raptor-1.4.2[curl]
	>=media-sound/jack-audio-connection-kit-0.120.1
	>=dev-libs/glib-2.2
	x11-libs/pango
	>=x11-libs/gtk+-2.8.8
	media-libs/flac
	>=media-libs/alsa-lib-1.0.14a-r1
	>=media-libs/libsamplerate-0.1.1-r1
	>=dev-libs/libxml2-2.6.0
	dev-libs/libxslt
	>=media-libs/libsndfile-1.0.18_pre24
	gnome-base/libgnomecanvas
	x11-themes/gtk-engines
	>=dev-cpp/gtkmm-2.12.3
	>=dev-cpp/glibmm-2.14.2
	>=dev-cpp/libgnomecanvasmm-2.20.0
	dev-cpp/cairomm
	>=dev-libs/libsigc++-2.0
	media-libs/libsoundtouch
	dev-libs/libusb
	=sci-libs/fftw-3*
	lv2? ( >=media-libs/slv2-0.6.1 )"

DEPEND="${RDEPEND}
	sys-devel/libtool
	dev-libs/boost
	dev-util/pkgconfig
	>=dev-util/scons-0.98.5
	nls? ( sys-devel/gettext )"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	# get the svn revision
	subversion_wc_info
	echo '#include "ardour/svn_revision.h"' > libs/ardour/svn_revision.cc
	echo "namespace ARDOUR { const char* svn_revision=\"$ESVN_WC_REVISION\"; }" >> libs/ardour/svn_revision.cc
	echo >> libs/ardour/svn_revision.cc

##	# some temporary slotting fixes
##	sed -i -e 's:ardour2:ardour3:' \
##		libs/rubberband/SConscript \
##		libs/clearlooks-older/SConscript \
##		|| die
##		# now it gets dirty... the locale files...
##	sed -e "s:share/locale:share/ardour3/locale:" \
##		-i SConstruct gtk2_ardour/SConscript || die
##	sed -e "s:'share', 'locale':'share', 'ardour3', 'locale':" \
##		-i libs/ardour/SConscript
}

src_compile() {

	local myconf="--freedesktop --noconfirm --prefix=/usr"
		use debug     && myconf="$myconf --debug"
		use nls       && myconf="$myconf --nls"
		use lv2       && myconf="$myconf --lv2"
		use sys-libs  && myconf="$myconf --syslibs"
		use tranzport && myconf="$myconf --tranzport"
		use freesound && myconf="$myconf --freesound"
		use wiimote   && myconf="$myconf --wiimote"
		use vst       && myconf="$myconf --vst"
	if use sse || use altivec ;then
		myconf="$myconf --fpu-optimization"
	fi

	einfo "./waf configure $myconf" # show configure options
	./waf configure $myconf || die "failed to configure"
	./waf build ${MAKEOPTS/-s/} || die "failed to build"
}

src_install() {
	./waf --destdir="${D}" install || die "install failed"
	#if use vst;then
	#	mv "${D}"/usr/bin/ardourvst "${D}"/usr/bin/ardour2
	#fi

	dodoc DOCUMENTATION/*

	#newicon "icons/icon/ardour_icon_tango_48px_blue.png" "ardour3.png"
	#make_desktop_entry "ardour3" "Ardour3" "ardour3" "AudioVideo;Audio"

	# fix wrapper
	#sed -i -e 's:ardour2:ardour3:g' ${D}/usr/bin/ardour3 || die
}

pkg_postinst() {
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update

	ewarn "---------------- WARNING -------------------"
	ewarn ""
	ewarn "MAKE BACKUPS OF THE SESSION FILES BEFORE TRYING THIS VERSION."
	ewarn ""
	ewarn "The simplest way to address this is to make a copy of the session file itself"
	ewarn "(e.g mysession/mysession.ardour) and make that file unreadable using chmod(1)."
	ewarn ""
}
