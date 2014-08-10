# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/ladish/ladish-9999.ebuild,v 1.3 2014/08/08 12:14:19 -tclover Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

PLOCALES="de fr ru"

inherit l10n python-single-r1 waf-utils git-2

DESCRIPTION="LADI Session Handler - a session management system for JACK applications"
HOMEPAGE="http://${PN}.org/"
EGIT_REPO_URI="git://repo.or.cz/ladish.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc gtk lash nls python"
REQUIRED_USE="python? ( lash ) ${PYTHON_REQUIRED_USE}"

S="${WORKDIR}"/${PN}-${P}

RDEPEND="lash? ( !media-sound/lash )
	media-sound/jack-audio-connection-kit[dbus]
	dev-libs/expat
	gtk? ( 
		dev-libs/boost
		>=x11-libs/gtk+-2.20.0:2
		>=x11-libs/flowcanvas-0.6.4
		>=dev-libs/glib-2.20.3
		>=dev-libs/dbus-glib-0.74
		>=gnome-base/libglade-2.6.2
	)
	sys-apps/dbus
	${PYTHON_DEPS}"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
	dev-util/intltool"

DOCS=( AUTHORS README NEWS )

src_prepare() {
	epatch "${FILESDIR}"/lash-1.0.pc.in.patch

	local LINGUAS="$(l10n_get_locales)"
	echo "${LINGUAS}" >po/LINGUAS
}

src_configure() {
	local NO_WAF_LIBDIR="yes"
	local mywafconfargs=(
		$(usex debug --debug '')
		$(usex doc --doxygen '')
		$(use_enable lash liblash)
		$(use_enable python pylash)
	)
	waf-utils_src_configure ${mywafconfargs[@]}
}

src_install() {
	use doc && HTML_DOC=( "${S}"/build/default/html )
	waf-utils_src_install
	python_fix_shebang "${ED}"
	use lash &&	dosym /usr/include/{lash-1.0/,}lash
}
