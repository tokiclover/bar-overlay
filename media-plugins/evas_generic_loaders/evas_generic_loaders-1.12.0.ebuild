# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/evas_generic_loaders/evas_generic_loaders-1.12.0.ebuild,v 1.1 2014/12/01 -tclover Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Provides external applications as generic loaders for Evas"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${PN}-${PV/_/-}.tar.xz"

LICENSE="GPL-2"
SLOT="0/${PV:0:4}"
KEYWORDS="~amd64 ~x86"
IUSE="gstreamer pdf postscript raw svg"

RDEPEND="
	>=dev-libs/efl-${PV:0:3}
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

