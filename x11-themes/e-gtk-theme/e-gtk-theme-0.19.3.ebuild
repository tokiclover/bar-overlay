# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://github.com/tokiclover/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="a gtk theme to match enlightenment DR17 default theme"
HOMEPAGE="https://github.com/tokiclover/e-gtk-theme"

LICENSE="BSD-2"
SLOT=0
IUSE="gnome gtk minimal openbox"

DEPEND="app-portage/elt-patches"
RDEPEND="!minimal? ( gtk? ( x11-themes/gnome-themes-standard ) )
	x11-themes/gtk-engines"

src_install()
{
	sed -e '/.*COPYING.*$/d' -i Makefile
	local themedir=/usr/share/themes/e
	emake DESTDIR="${ED}" prefix=/usr install-all
	use gnome   || rm -fr "${ED}"/${themedir}/metacity-1
	use openbox || rm -fr "${ED}"/${themedir}/openbox-3
}
