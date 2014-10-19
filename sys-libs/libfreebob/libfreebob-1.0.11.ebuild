# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-libs/libfreebob/libfreebob-1.0.11.ebuild,v 1.0 2014/10/10 -tclover Exp $

EAPI=5

inherit eutils base autotools-multilib

DESCRIPTION="Library for accessing BeBoB IEEE1394 devices"
HOMEPAGE="http://freebob.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc amd64 ~ppc ~ppc-macos ~mips"

IUSE=""

DEPEND=">=media-libs/alsa-lib-1.0.0[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.6.0[${MULTILIB_USEDEP}]
	>=sys-libs/libraw1394-1.2.1[${MULTILIB_USEDEP}]
	>=media-libs/libiec61883-1.1.0[${MULTILIB_USEDEP}]
	>=sys-libs/libavc1394-0.5.3[${MULTILIB_USEDEP}]
	>=media-sound/jack-audio-connection-kit-0.102.20[${MULTILIB_USEDEP}]"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
)

AUTOTOOLS_AUTORECONF=1

src_prepare()
{
	autotools-utils_src_prepare
	mulutilib_copy_sources
}

multilib_src_configure()
{
	autotools-utils_src_configure
}
