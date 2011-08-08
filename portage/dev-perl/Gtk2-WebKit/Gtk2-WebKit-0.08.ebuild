# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Gtk2-WebKit/Gtk2-WebKit-0.08.ebuild,v 1.2 2011/03/21 23:30:53 nirbheek Exp $

EAPI=1
MODULE_AUTHOR=FLORA
inherit perl-module

DESCRIPTION="Web content engine library for Gtk2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/gtk2-perl
	net-libs/webkit-gtk:2"
DEPEND="${RDEPEND}
	dev-perl/glib-perl
	dev-perl/extutils-pkgconfig
	dev-perl/extutils-depends"

src_configure() {
	addpredict "/usr/local/share/webkit"
	perl-module_src_configure
	ewarn "copy over /usr/local/share/webkit to ~/.local/share/webkit"
}

#SRC_TEST=do
