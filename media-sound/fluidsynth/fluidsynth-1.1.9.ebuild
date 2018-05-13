# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://sourceforge.net/p/${PN}/code-git.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
		SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
		;;
esac
inherit cmake-multilib ${VCS_ECLASS}

DESCRIPTION="Fluidsynth is a software real-time synthesizer based on the Soundfont 2 specifications."
HOMEPAGE="http://www.fluidsynth.org/"

LICENSE="LGPL-2"
SLOT="0"
IUSE="+alsa dbus debug doc ipv6 +jack ladspa +lash portaudio pulseaudio readline sndfile"
REQUIRE_USE="lash? ( alsa )"

RDEPEND=">=dev-libs/glib-2.6.5:2
	alsa? ( >=media-libs/alsa-lib-0.9.1 )
	lash? ( virtual/liblash )
	dbus? ( >=sys-apps/dbus-1.0.0 )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( >=media-libs/ladspa-sdk-1.12
		>=media-libs/ladspa-cmt-1.15 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.8 )
	portaudio? ( >=media-libs/portaudio-19_pre )
	readline? ( sys-libs/readline )
	sndfile? ( >=media-libs/libsndfile-1.0.18 )"
DEPEND="${RDEPEND}
	app-doc/doxygen
	app-portage/elt-patches
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README.md THANKS TODO )

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/configure.ac.patch
)


src_configure()
{
	# autotools based build system has AC_CHECK_LIB(pthread, pthread_create) wrt
	# bug #436762
	append-flags -pthread

	local -a mycmakeargs=(
		$(cmake-utils_use alsa enable-alsa)
		$(cmake-utils_use dbus enable-dbus)
		$(cmake-utils_use debug enable-debug)
		$(cmake-utils_use ipv6 enable-ipv6)
		$(cmake-utils_use jack enable-jack)
		-Denable-ladcca=OFF
		$(cmake-utils_use ladspa enable-ladspa)
		$(cmake-utils_use lash enable-lash)
		$(cmake-utils_use sndfile enable-libsndfile)
		$(cmake-utils_use portaudio enable-portaudio)
		$(cmake-utils_use pulseaudio enable-pulseaudio)
		$(cmake-utils_use readline enable-readline)
	)
	cmake-multilib_src_configure
}

src_install()
{
	cmake-multilib_src_install

	if use doc; then
		insinto /usr/share/doc/${PF}/pdf
		doins doc/FluidSynth-LADSPA.pdf
		insinto /usr/share/doc/${PF}/src
		doins doc/*.c
		dodoc doc/{xtrafluid,fluidsynth-v11-devdoc}.txt
	fi
}

