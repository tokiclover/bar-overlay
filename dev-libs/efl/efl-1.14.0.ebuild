# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-libs/efl/efl-1.14.0.ebuild,v 1.3 2015/05/26 -tclover Exp $

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
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://download.enlightenment.org/rel/libs/${PN}/${P/_/-}.tar.xz"
	;;
esac
inherit autotools-multilib ${VCS_ECLASS}

RESTRICT="test"

DESCRIPTION="Enlightenment Foundation Core Libraries"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${P/_/-}.tar.xz"

LICENSE="BSD-2 GPL-2 LGPL-2.1 ZLIB"
SLOT="0/${PV:0:4}"

IUSE="+X avahi cxx-bindings debug doc drm +egl fbcon +fontconfig +fribidi gif
gles glib gnutls gstreamer harfbuzz ibus jp2k +nls +opengl ssl physics +png
pulseaudio scim sdl static-libs systemd system-lz4 test tiff tslib v4l2 wayland
webp xim xine xpm"
REQUIRED_USE="drm? ( systemd ) ?? ( gnutls ssl ) ?? ( opengl gles sdl )"

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
	!gnutls? ( ssl? ( dev-libs/openssl[${MULTILIB_USEDEP}] ) )
	gstreamer? (
		media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}]
	)
	harfbuzz? ( media-libs/harfbuzz[${MULTILIB_USEDEP}] )
	ibus? ( app-i18n/ibus )
	jp2k? ( media-libs/openjpeg[${MULTILIB_USEDEP}] )
	nls? ( virtual/libintl[${MULTILIB_USEDEP}] )
	physics? ( sci-physics/bullet )
	png? ( media-libs/libpng:0=[${MULTILIB_USEDEP}] )
	pulseaudio? (
		media-sound/pulseaudio[${MULTILIB_USEDEP}]
		media-libs/libsndfile[${MULTILIB_USEDEP}]
	)
	scim?	( app-i18n/scim )
	sdl? (
		>=media-libs/libsdl2-2.0.0:0[opengl?,gles?,${MULTILIB_USEDEP}]
	)
	systemd? ( sys-apps/systemd[${MULTILIB_USEDEP}] )
	system-lz4? ( >=app-arch/lz4-120[${MULTILIB_USEDEP}] )
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
	app-arch/xz-utils
	doc? ( app-doc/doxygen )
	test? ( dev-libs/check[${MULTILIB_USEDEP}] )"

DOCS=( AUTHORS ChangeLog NEWS README )

S="${WORKDIR}/${P/_/-}"

multilib_src_configure()
{
	local -a myeconfargs=( ${EXTRA_EFL_CONF} )

	# gnutls / openssl
	if ! (use gnutls || use ssl); then
		myeconfargs+=( --with-crypto=none )
	fi
	# X
	myeconfargs+=(
		$(use_with X x)
		$(use_with X x11 xlib)
	)
	if ! (use opengl || use gles); then
		myeconfargs+=( --with-opengl=none )
	fi
	# wayland
	myeconfargs+=(
		$(use_enable egl)
		$(use_enable wayland)
	)
	myeconfargs+=(
		$(use_enable avahi)
		$(use_enable cxx-bindings cxx-bindings)
		$(use_enable doc)
		$(use_enable drm)
		$(use_enable fbcon fb)
		$(use_enable fontconfig)
		$(use_enable fribidi)
		$(usex opengl '--with-opengl=full' '')
		$(usex gles '--with-opengl=es' '')
		$(use_enable gstreamer gstreamer1)
		$(usex gnutls '--with-crypto=gnutls' '')
		$(usex ssl '--with-crypto=openssl' '')
		$(use_enable harfbuzz)
		$(use_enable ibus)
		$(use_enable nls)
		$(use_enable physics)
		$(use_enable pulseaudio)
		$(use_enable pulseaudio audio)
		$(use_enable scim)
		$(use_enable sdl)
		$(use_enable static-libs static)
		$(use_enable systemd)
		$(use_enable system-lz4 liblz4)
		$(use_enable tslib)
		$(use_enable v4l2)
		$(use_enable xim)
		$(use_enable xine)
		# image loders
		--enable-image-loader-bmp
		--enable-image-loader-eet
		--enable-image-loader-generic
		--enable-image-loader-ico
		--enable-image-loader-jpeg # required by ethumb
		--enable-image-loader-psd
		--enable-image-loader-pmaps
		--enable-image-loader-tga
		--enable-image-loader-wbmp
		$(use_enable gif image-loader-gif)
		$(use_enable jp2k image-loader-jp2k)
		$(use_enable png image-loader-png)
		$(use_enable tiff image-loader-tiff)
		$(use_enable webp image-loader-webp)
		$(use_enable xpm image-loader-xpm)
		--enable-cserve
		--enable-libmount
		--enable-threads
		--enable-xinput22
		--disable-gesture
		--disable-gstreamer # using gstreamer1
		--disable-lua-old
		--disable-multisense
		--disable-tizen
		--disable-xinput2
		--disable-xpresent
		# bug 501074
		--disable-pixman
		--disable-pixman-font
		--disable-pixman-rect
		--disable-pixman-line
		--disable-pixman-poly
		--disable-pixman-image
		--disable-pixman-image-scale-sample
		--with-profile=$(usex debug debug release)
		--with-glib=$(usex glib yes no)
		--with-tests=$(usex test regular none)
		--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-aba
	)
	autotools-utils_src_configure
}
