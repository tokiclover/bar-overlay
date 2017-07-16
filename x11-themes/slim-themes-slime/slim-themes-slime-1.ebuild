# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: x11-themes/slim-themes-slime/slim-themes-slime-0.19.3.ebuild,v 1.1 2015/06/22 14:23:22 Exp $

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
