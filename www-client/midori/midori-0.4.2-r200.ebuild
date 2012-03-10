# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/midori/midori-0.4.2-r200.ebuild,v 1.1 2011/12/06 03:50:25 ssuominen Exp $

EAPI=4
inherit eutils fdo-mime gnome2-utils python waf-utils

PV_vala_version=0.14

DESCRIPTION="A lightweight web browser based on WebKitGTK+"
HOMEPAGE="http://www.twotoasts.de/index.php?/pages/midori_summary.html"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x86-fbsd"
IUSE="doc gnome libnotify nls +unique"

RDEPEND="dev-db/sqlite:3
	>=dev-libs/glib-2.22
	dev-libs/libxml2
	net-libs/libsoup:2.4
	net-libs/webkit-gtk:2
	x11-libs/gtk+:2
	x11-libs/libXScrnSaver
	gnome? ( net-libs/libsoup-gnome:2.4 )
	libnotify? ( x11-libs/libnotify )
	unique? ( dev-libs/libunique:1 )"
DEPEND="${RDEPEND}
	|| ( dev-lang/python:2.7 dev-lang/python:2.6 )
	dev-lang/vala:${PV_vala_version}
	dev-util/intltool
	gnome-base/librsvg
	doc? ( dev-util/gtk-doc )
	nls? ( sys-devel/gettext )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	DOCS=( AUTHORS ChangeLog HACKING INSTALL TODO TRANSLATE )
	HTML_DOCS=( data/faq.html data/faq.css )
}

src_configure() {
	strip-linguas -i po

	VALAC="$(type -P valac-${PV_vala_version})" \
	waf-utils_src_configure \
		--disable-docs \
		 $(use_enable doc apidocs) \
		 $(use_enable unique) \
		 $(use_enable libnotify) \
		--enable-addons \
		$(use_enable nls)
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
