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

DESCRIPTION="SLiM theme to match e-gtk-theme"
HOMEPAGE="https://github.com/tokiclover/slim-themes-slime"

LICENSE="BSD-2"
SLOT=0
IUSE=""

DEPEND=""
RDEPEND="x11-misc/slim
	media-fonts/artwiz-latin1"

src_install()
{
	sed -e '/.*COPYING.*$/d' -i Makefile
	emake DESTDIR="${ED}" PREFIX=/usr install
}
