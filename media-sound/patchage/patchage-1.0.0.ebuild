# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/patchage/patchage-0.5.0.ebuild,v 1.7 2015/06/01 08:45:11 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE='threads(+)'

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=subversion
	ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk/${PN}"
	ESVN_PROJECT="${PN}"
	;;
	(*)
	KEYWORDS="~amd64 ~ppc ~x86"
	SRC_URI="http://download.drobilla.net/${P}.tar.bz2"
	;;
esac
inherit eutils toolchain-funcs python-any-r1 waf-utils ${VCS_ECLASS}

DESCRIPTION="Modular patch bay for audio and MIDI systems"
HOMEPAGE="http://wiki.drobilla.net/Patchage"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa dbus debug jack-session"

RDEPEND="dev-libs/boost
	>=media-libs/ganv-1.4.0
	>=dev-cpp/gtkmm-2.11.12:2.4
	>=dev-cpp/glibmm-2.14:2
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

