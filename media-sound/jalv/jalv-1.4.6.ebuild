# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/jalv/jalv-1.4.6.ebuild,v 1.7 2015/06/01 08:45:11 -tclover Exp $

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

DESCRIPTION="Simple and fully featured LV2 host for Jack running and exposing LV2 plugins as JACK applications"
HOMEPAGE="http://drobilla.net/software/jalv"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug gtk gtk3 jack-session qt4"

GTK_COMMON_DEP=">=dev-cpp/gtkmm-2.11.12:2.4"
RDEPEND=">=dev-libs/serd-0.14.0
	>=dev-libs/sord-0.12.0
	>=media-libs/suil-0.6.0
	>=media-libs/sratom-0.4.0
	>=media-libs/lv2-1.8.1
	>=media-libs/lilv-0.19.2
	>=x11-libs/ganv-1.4.0
	gtk?  ( x11-libs/gtk+:2 ${GTK_COMMON_DEP} )
	gtk3? ( x11-libs/gtk+:3 ${GTK_COMMON_DEP} )
	qt4?  ( dev-qt/qtgui:4 )
	>=media-sound/jack-audio-connection-kit-0.120"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

DOCS=( AUTHORS README NEWS )

src_configure()
{
	local -a mywafargs=(
		--prefix=/usr
		$(use debug && echo '--debug')
		$(use jack-session || echo '--no-jack-session')
		$(use qt4 || echo '--no-qt')
	)
	waf-utils_src_configure "${mywafargs[@]}"
}

