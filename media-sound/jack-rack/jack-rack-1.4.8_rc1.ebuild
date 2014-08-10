# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/jack-rack/jack-rack-1.4.8_rc1.ebuild,v 1.4 2014/08/08 17:48:37 -tclover Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1

PLOCALES="cs de fr ru"

inherit l10n autotools-utils flag-o-matic toolchain-funcs

MY_P=${PN}_${PV/_/\~}
DEB_URI="mirror://debian/pool/main/j/${PN}"

DESCRIPTION="JACK Rack is an effects rack for the JACK low latency audio API."
HOMEPAGE="http://jack-rack.sourceforge.net/"
SRC_URI="${DEB_URI}/${MY_P}.orig.tar.gz ${DEB_URI}/${MY_P}-1.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa gnome ladspa lash nls"
REQUIRED_USE="lash? ( alsa )"

RDEPEND=">=x11-libs/gtk+-2.12:2
	>=media-libs/ladspa-sdk-1.12
	>=media-sound/jack-audio-connection-kit-0.50.0
	alsa? ( >=media-libs/alsa-lib-0.9 )
	lash? ( virtual/liblash )
	gnome? ( >=gnome-base/libgnomeui-2 )
	ladspa? ( dev-libs/libxml2 media-libs/liblrdf )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( virtual/libintl )"

DOCS=( AUTHORS BUGS ChangeLog NEWS README THANKS TODO WISHLIST )

EPATCH_FORCE=yes

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.6-noalsa.patch
	"${FILESDIR}"/${PN}-1.4.7-disable_deprecated.patch
)

src_unpack() {
	unpack ${A}
	mv ${PN}-* ${P} || die
}

src_prepare() {
	local LINGUAS
	use nls && LINGUAS="$(l10n_get_locales)"
	echo "${LINGUAS}" >po/LANGUAS
	
	PATCHES=( ${PATCHES[@]} "${WORKDIR}"/debian/patches/*.patch )

	sed -e '/Categories/s:Application:GTK:' \
		-e '/Icon/s:.png::' \
		-i ${PN}.desktop || die

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfarg=(
		$(use_enable alsa aseq)
		$(use_enable gnome)
		$(use_enable ladspa xml)
		$(use_enable ladspa lrdf)
		$(use_enable lash)
	)
	autotools-utils_src_configure
}
