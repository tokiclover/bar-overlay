# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/dev-perl/perl-WebKit-GTk/perl-WebKit-GTk-0.90.0.ebuild,v 1.1 2012/08/05 09:49:25 -tclover Exp $

EAPI=5

MODULE_AUTHOR=FLORA
MODULE_VERSION=0.09
MY_PN=Gtk2-WebKit
inherit perl-module

DESCRIPTION="perl WebKit module for the GIMP Toolkit"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-perl/gtk2-perl
	net-libs/webkit-gtk:2"
DEPEND="${RDEPEND}
	dev-perl/glib-perl
	dev-perl/extutils-pkgconfig
	dev-perl/extutils-depends"

src_configure() {
	addpredict /usr/share/webkit
	perl-module_src_configure
}
