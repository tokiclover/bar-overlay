# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/patchage/patchage-0.5.0.ebuild,v 1.5 2014/10/10 08:45:11 -tclover Exp $

EAPI=5

inherit eutils toolchain-funcs waf-utils

DESCRIPTION="Modular patch bay for audio and MIDI systems"
HOMEPAGE="http://wiki.drobilla.net/Patchage"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa dbus debug jack-session"

RDEPEND="dev-libs/boost
	>=x11-libs/ganv-1.4.0
	>=dev-cpp/gtkmm-2.11.12:2.4
	>=dev-cpp/glibmm-2.14:2
	>=x11-libs/ganv-1.4
	>=media-sound/jack-audio-connection-kit-0.107[dbus?]
	alsa? ( media-libs/alsa-lib )
	dbus? ( dev-libs/dbus-glib sys-apps/dbus )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README NEWS )

src_configure()
{
	local -a mywafargs=(
		--prefix=/usr
		$(use debug && echo '--debug')
		$(use alsa || echo '--no-alsa')
		$(use dbus || echo '--jack-dbus')
		$(use jack-session && echo '--jack-session-manage')
	)
	waf-utils_src_configure "${mywafargs[@]}"
}

