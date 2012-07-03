# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="A collection of bridges to LV2 which allows use of LADSPA and DSSI plugins in LV2 hosts"
HOMEPAGE="http://naspro.atheme.org/naspro-bridges/about"
SRC_URI="mirror://sourceforge/naspro/naspro/${PV}/${P}.tar.bz2"
RESTRICT="mirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	>=media-libs/naspro-core-${PV}
	>=media-libs/naspro-bridge-it-${PV}
	|| ( >=media-libs/lv2core-4.0 media-libs/lv2 )
	>=media-libs/ladspa-sdk-1.13
	>=media-libs/dssi-1.0.0
	>=media-libs/lv2-dyn-manifest-1.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf --disable-dependency-tracking --disable-static || die
}

src_install() {
	make DESTDIR="${D}" install || die
	find "${D}" -name '*.la' -delete || die
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
