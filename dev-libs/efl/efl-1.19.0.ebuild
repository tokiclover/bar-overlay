# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

case "${PV}" in
	(*9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://git.enlightenment.org/core/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	case "${PV}" in
		(*.9999*) EGIT_BRANCH="${PN}-${PV:0:4}";;
	esac
	AUTOTOOLS_AUTORECONF=1
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://download.enlightenment.org/rel/libs/${PN}/${P/_/-}.tar.xz"
	S="${WORKDIR}/${P/_/-}"
	;;
esac
inherit autotools-multilib ${VCS_ECLASS}

RESTRICT="test"

DESCRIPTION="Enlightenment Foundation Core Libraries"
HOMEPAGE="http://www.enlightenment.org/"

LICENSE="BSD-2 FTL GPL-2 LGPL-2.1 ZLIB"
SLOT="0/${PV:0:4}"

IUSE="+X avahi +bmp cpu_flags_arm_neon cxx-bindings debug doc drm +eet +egl fbcon
+fontconfig +fribidi gif gles glib gnutls gstreamer harfbuzz ibus +ico jpeg2k libuv
+nls +opengl raw ssl svg pdf +postscript physics pixman +png +ppm +psd  pulseaudio
scim sdl sndfile static-libs systemd system-lz4 test +tga tiff tslib v4l2 wayland
webp xim xine xpm"
REQUIRED_USE="
	?? ( gnutls ssl )
	?? ( opengl gles )
	?? ( glib libuv )
	drm? ( systemd )
	gles? ( !sdl egl )
	gles? ( || ( X wayland ) )
	opengl? ( !egl )
	pulseaudio? ( sndfile )
	sdl? ( !gles opengl )
	xim? ( X )
	wayland? ( egl !opengl gles )
"

COMMON_DEP="
	dev-lang/luajit:2
	sys-apps/dbus[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	virtual/jpeg[${MULTILIB_USEDEP}]
	virtual/udev
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXScrnSaver[${MULTILIB_USEDEP}]
		x11-libs/libXcomposite[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXdamage[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXinerama[${MULTILIB_USEDEP}]
		x11-libs/libXp[${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-libs/libXrender[${MULTILIB_USEDEP}]
		x11-libs/libXtst[${MULTILIB_USEDEP}]
		gles? (
			media-libs/mesa[egl,gles2,${MULTILIB_USEDEP}]
			x11-libs/libXrender[${MULTILIB_USEDEP}]
		)
		opengl? (
			virtual/opengl[${MULTILIB_USEDEP}]
			x11-libs/libXrender[${MULTILIB_USEDEP}]
		)
	)
	avahi? ( net-dns/avahi[${MULTILIB_USEDEP}] )
	debug? ( dev-util/valgrind )
	drm? ( x11-libs/libdrm[${MULTILIB_USEDEP}]
		x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
		media-libs/mesa[gbm,${MULTILIB_USEDEP}]
		dev-libs/libinput
	)
	fontconfig? ( media-libs/fontconfig[${MULTILIB_USEDEP}] )
	fribidi? ( dev-libs/fribidi[${MULTILIB_USEDEP}] )
	gif? ( media-libs/giflib[${MULTILIB_USEDEP}] )
	glib? ( dev-libs/glib[${MULTILIB_USEDEP}] )
	gnutls? ( net-libs/gnutls[${MULTILIB_USEDEP}] )
	ssl? ( || ( dev-libs/libressl[${MULTILIB_USEDEP}]
		dev-libs/openssl[${MULTILIB_USEDEP}] ) )
	svg? ( gnome-base/librsvg[${MULTILIB_USEDEP}] )
	gstreamer? (
		media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}]
	)
	harfbuzz? ( media-libs/harfbuzz[${MULTILIB_USEDEP}] )
	ibus? ( app-i18n/ibus )
	jpeg2k? ( media-libs/openjpeg[${MULTILIB_USEDEP}] )
	libuv? ( dev-libs/libuv[${MULTILIB_USEDEP}] )
	nls? ( virtual/libintl[${MULTILIB_USEDEP}] )
	pdf? ( app-text/poppler[cxx,jpeg,jpeg2k?] )
	postscript? ( app-text/libspectre )
	pixman? ( x11-libs/pixman[${MULTILIB_USEDEP}] )
	physics? ( sci-physics/bullet )
	png? ( media-libs/libpng:0=[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-sound/pulseaudio[${MULTILIB_USEDEP}] )
	sndfile? ( media-libs/libsndfile[${MULTILIB_USEDEP}] )
	raw? ( media-libs/libraw[${MULTILIB_USEDEP}] )
	scim?	( app-i18n/scim )
	sdl? (
		>=media-libs/libsdl2-2.0.0:0[opengl?,gles?,${MULTILIB_USEDEP}]
	)
	systemd? ( sys-apps/systemd[${MULTILIB_USEDEP}] )
	system-lz4? ( >=app-arch/lz4-0_p120[${MULTILIB_USEDEP}] )
	tiff? ( media-libs/tiff:0[${MULTILIB_USEDEP}] )
	tslib? ( x11-libs/tslib[${MULTILIB_USEDEP}] )
	wayland? (
		>=dev-libs/wayland-1.3.0:0[${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-0.3.1[${MULTILIB_USEDEP}]
		egl? ( media-libs/mesa[egl,gles2,${MULTILIB_USEDEP}] )
	)
	webp? ( media-libs/libwebp[${MULTILIB_USEDEP}] )
	xine? ( >=media-libs/xine-lib-1.1.1[${MULTILIB_USEDEP}] )
	xpm? ( x11-libs/libXpm[${MULTILIB_USEDEP}] )"
RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}
	!!dev-libs/ecore
	!!dev-libs/edbus
	!!dev-libs/eet
	!!dev-libs/eeze
	!!dev-libs/efreet
	!!dev-libs/eina
	!!dev-libs/eio
	!!dev-libs/embryo
	!!dev-libs/eobj
	!!dev-libs/ephysics
	!!media-libs/edje
	!!media-libs/emotion
	!!media-libs/ethumb
	!!media-libs/evas
	!!media-libs/elementary
	app-arch/xz-utils
	app-portage/elt-patches
	doc? ( app-doc/doxygen )
	test? ( dev-libs/check[${MULTILIB_USEDEP}] )"

unset COMMON_DEP
DOCS=( AUTHORS COMPLIANCE COPYING ChangeLog NEWS README )

multilib_src_configure()
{
	local -a myeconfargs=( ${EXTRA_EFL_CONF} )

	use opengl && use drm && myeconfargs+=( --enable-gl-drm )
	use gles && use fbcon && myeconfargs+=( --enable-eglfs )
	myeconfargs+=(
		$(use_enable avahi)
		$(use_enable cpu_flags_arm_neon neon)
		$(use_enable cxx-bindings cxx-bindings)
		$(use_enable doc)
		$(use_enable drm)
		$(use_enable egl)
		$(use_enable fbcon fb)
		$(use_enable fontconfig)
		$(use_enable fribidi)
		$(use_enable gstreamer gstreamer1)
		$(use_enable harfbuzz)
		$(use_enable ibus)
		$(use_enable libuv)
		$(use_enable nls)
		$(use_enable pdf poppler)
		$(use_enable postscript spectre)
		$(use_enable physics)
		$(use_enable pulseaudio)
		$(use_enable pulseaudio audio)
		$(use_enable raw libraw)
		$(use_enable scim)
		$(use_enable sdl)
		$(use_enable sndfile audio)
		$(use_enable static-libs static)
		$(use_enable svg librsvg)
		$(use_enable systemd)
		$(use_enable system-lz4 liblz4)
		$(use_enable tslib)
		$(use_enable v4l2)
		$(use_enable wayland)
		$(use_enable xim)
		$(use_enable xine)
		$(use_enable bmp image-loader-bmp)
		$(use_enable bmp image-loader-wbmp)
		$(use_enable eet image-loader-eet)
		$(use_enable ico image-loader-ico)
		$(use_enable jpeg2k image-loader-jp2k)
		$(use_enable psd image-loader-psd)
		$(use_enable ppm image-loader-pmaps)
		$(use_enable tga image-loader-tga)
		$(use_enable gif image-loader-gif)
		$(use_enable pixman)
		$(use_enable pixman pixman-font)
		$(use_enable pixman pixman-rect)
		$(use_enable pixman pixman-line)
		$(use_enable pixman pixman-poly)
		$(use_enable pixman pixman-image)
		$(use_enable pixman pixman-image-scale-sample)
		$(use_enable png image-loader-png)
		$(use_enable tiff image-loader-tiff)
		$(use_enable webp image-loader-webp)
		$(use_enable xpm image-loader-xpm)
		--with-crypto=$(usex gnutls gnutls $(usex ssl openssl none))
		--with-opengl=$(usex opengl full $(usex gles es none))
		--with-profile=$(usex debug debug release)
		--with-glib=$(usex glib yes no)
		--with-tests=$(usex test regular none)
		--with-x11=$(usex X xlib none)
		$(use_with X x)

		--enable-image-loader-generic
		--enable-image-loader-jpeg
		--enable-cserve
		--enable-libmount
		--enable-xinput2
		--disable-xinput22
		--disable-gesture
		--disable-gstreamer
		--disable-lua-old
		--disable-multisense
		--disable-tizen
		--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-abb
	)
	autotools-utils_src_configure
}
