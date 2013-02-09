# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/x11-plugins/e_modules/e_modules-9999.ebuild,v 1.6 2012/12/10 11:03:18 -tclover Exp $

EAPI=2

EGIT_REPO_URI="git://github.com/jeffdameth/ecomorph.git"
EGIT_BOOTSTRAP="enlightenment_src_prepare"

inherit enlightenment git

DESCRIPTION="Ecomorph is a compositing manager for e17"

IUSE="static-libs"

CDEPEND=">=media-libs/edje-0.5.0
	>=x11-wm/enlightenment-0.17_alpha1
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/mesa
	sys-apps/dbus"
DEPEND="${CDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/libtool"
RDEPEND="${CDEPEND}
	x11-apps/mesa-progs
	x11-apps/xdpyinfo
	x11-wm/ecomp"

pkg_postinst() {
	elog "if you want to start ecomp with the ecomorph module,"
	elog "then you either need xterm installed or a symlink for"
	elog "it in your path, since ecomorph uses the xterm command"
	elog "to start ecomp. You can safely close the appearing window"
	elog "after starting ecomp and it will run in the background"
}
