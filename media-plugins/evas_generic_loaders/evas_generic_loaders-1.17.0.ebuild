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
	SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${PN}-${PV/_/-}.tar.xz"
	;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="Provides external applications as generic loaders for Evas"
HOMEPAGE="http://www.enlightenment.org/"

LICENSE="GPL-2"
SLOT="0/${PV:0:4}"
IUSE="gstreamer pdf postscript raw svg"

RDEPEND="
	>=dev-libs/efl-1.7.0
	gstreamer? (
		media-libs/gstreamer:1.0
	)
	pdf? ( app-text/poppler:0= )
	postscript? ( app-text/libspectre )
	raw? ( media-libs/libraw )
	svg? (
		gnome-base/librsvg
		x11-libs/cairo
	)"
DEPEND="${RDEPEND}
	app-portage/elt-patches
	app-arch/xz-utils"

S="${WORKDIR}/${PN}-${PV/_/-}"

src_configure()
{
	local -a myeconfargs=(
		${EXTRA_EGL_CONF}
		$(use_enable gstreamer)
		$(use_enable gstreamer gstreamer1)
		$(use_enable pdf poppler)
		$(use_enable postscript spectre)
		$(use_enable raw libraw)
		$(use_enable svg)
	)
	autotools-utils_src_configure
}

