# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/patchage/patchage-0.5.0.ebuild,v 1.7 2015/05/01 08:45:11 Exp $

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
inherit toolchain-funcs python-any-r1 waf-utils ${VCS_ECLASS}

DESCRIPTION="Modular patch bay for audio and MIDI systems"
HOMEPAGE="http://wiki.drobilla.net/Patchage"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa debug lash"

RDEPEND=">=media-libs/raul-0.7.0
	>=x11-libs/flowcanvas-0.7.1
	>=dev-cpp/gtkmm-2.11.12:2.4
	>=dev-cpp/glibmm-2.14:2
	>=dev-cpp/libglademm-2.6.0:2.4
	dev-cpp/libgnomecanvasmm:2.6
	dev-libs/boost
	>=media-sound/jack-audio-connection-kit-0.107
	alsa? ( media-libs/alsa-lib )
	lash? ( dev-libs/dbus-glib )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

DOCS=( AUTHORS README ChangeLog )

src_configure()
{
	local -a mywafargs=(
		--prefix=/usr
		$(use debug && echo '--debug')
		$(use alsa || echo '--no-alsa')
		$(use lash || echo '--no-lash')
	)
	waf-utils_src_configure "${mywafargs[@]}"
}

