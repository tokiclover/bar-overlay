# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/patchage/patchage-0.5.0.ebuild,v 1.6 2015/02/10 08:45:11 -tclover Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE='threads(+)'

inherit eutils toolchain-funcs python-any-r1 waf-utils

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
	${PYTHON_DEPS}
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

