# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit cmake-utils flag-o-matic

DESCRIPTION="Open source web browser engine--EFL port from gtk library"
HOMEPAGE="http://trac.webkit.org/wiki/EFLWebKit"

SRC_URI="http://packages.profusion.mobi/${PN}/${PN}-svn-r${PV/0.1.}.tar.bz2"
E_STATE="snapshot"
WANT_AUTOTOOLS="no"

LICENSE="LGPL-2 LGPL-2.1 BSD"
IUSE="curl glib gstreamer plugins static-libs xhtml"
SLOT="0"

DEPEND="${RDEPEND}
    >=sys-devel/flex-2.5.33
    sys-devel/bison
	dev-util/gperf
	dev-lang/python
	dev-lang/perl
"
RDEPEND="
		media-libs/edje
		media-libs/evas[fontconfig]
		dev-libs/ecore[X,glib?]
"

RDEPEND="${RDEPEND}
		dev-libs/libxslt
		virtual/jpeg:0
		media-libs/libpng
		x11-libs/cairo
		gstreamer? (
			media-libs/gstreamer:0.10
			>=media-libs/gst-plugins-base-0.10.25:0.10
			dev-libs/glib
			)
		glib? ( 
			dev-libs/glib
			net-libs/libsoup 
			)
		!glib? ( net-misc/curl )
		>=dev-db/sqlite-3
		!curl? ( net-libs/libsoup )
"

CMAKE_IN_SOURCE_BUILD="enable"
S="${WORKDIR}/${PN}-svn-r${PV/0.1.}"

src_configure() {
		[ gcc-major-version == 4 ] && [ gcc-minor-version == 4 ] && append-flags -fno-strict-aliasing

		sed -i -e "s:NOPORT:Efl:g" CMakeLists.txt || die "eek!"
		MYCMAKEARGS=" -DSHARED_CORE=ON -DPORT=Efl"
		use static-libs && MYCMAKEARGS="${MYCMAKEARGS/SHARED_CORE=ON/SHARED_CORE=OFF/}"
		use curl && MYCMAKEARGS+=" -DNETWORK_BACKEND=curl" || \ 
		MYCMAKEARGS+=" -DNETWORK_BACKEND=soup"
		use gstreamer && use !glib && die "gtsreamer requiire glib USE flag." || \
            MYCMAKEARGS="${MYCMAKEARGS/curl/soup}"
   		use plugins && MYCMAKEARGS+=" -DNETSCAPE_PLUGIN_API=ON"
		MYCMAKEARGS+=" $(cmake-utils_use_enable gstreamer VIDEO) \
					   $(cmake-utils_use_enable glib GLIB_SUPPORT) \
					   $(cmake-utils_use_enable xhtml XHTML) 
					   "
		enable_cmake-utils_src_configure
}

src_install() {
		cmake -DCMAKE_INSTALL_PREFIX="${D}"/usr -P cmake_install.cmake || die "eek!"
}
