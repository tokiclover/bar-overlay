# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/jack-rack/jack-rack-9999.ebuild,v 1.1 2014/07/15 17:48:37 -tclover Exp $

EAPI="5"

inherit autotools-utils flag-o-matic toolchain-funcs git-2


DESCRIPTION="JACK Rack is an effects rack for the JACK low latency audio API."
HOMEPAGE="http://jack-rack.sourceforge.net/"
EGIT_REPO_URI="git://sourceforge.net/p/jack-rack.git"
EGIT_PROJECT=${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa gnome ladspa lash nls"
REQUIRED_USE="lash? ( alsa )"

LANGS="cs de fr ru"
for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

RDEPEND=">=x11-libs/gtk+-2.12:2
	>=media-libs/ladspa-sdk-1.12
	>=media-sound/jack-audio-connection-kit-0.50.0
	alsa? ( >=media-libs/alsa-lib-0.9 )
	lash? ( virtual/liblash )
	gnome? ( >=gnome-base/libgnomeui-2 )
	ladspa? ( dev-libs/libxml2 media-libs/liblrdf )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext virtual/libintl )"

DOCS=( AUTHORS BUGS ChangeLog NEWS README THANKS TODO WISHLIST )

src_prepare() {
	local langs
	if use nls; then
		for l in ${LANGS}; do
			use linguas_${l} && langs+=" ${l}" ||
			has ${l} ${LINGUAS} && langs+=" ${l}"
		done
	fi
	echo "${langs}" >po/LANGUAS
	
	EPATCH_FORCE=yes EPATCH_SUFFIX=patch epatch "${WORKDIR}"/debian/patches

	epatch \
		"${FILESDIR}"/${PN}-1.4.6-noalsa.patch \
		"${FILESDIR}"/${PN}-1.4.7-disable_deprecated.patch

	sed -e '/Categories/s:Application:GTK:' \
		-e '/Icon/s:.png::' \
		-i ${PN}.desktop || die

	autotools-utils_src_preapre
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
