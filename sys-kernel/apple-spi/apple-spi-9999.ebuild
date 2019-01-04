# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic linux-mod toolchain-funcs git-2

DESCRIPTION="Apple SPI driver"
HOMEPAGE="http://github.com/cb22/macbook12-spi-driver/"
EGIT_REPO_URI="git://github.com/cb22/macbook12-spi-driver.git"
EGIT_PROJECT="${PN}.git"

DEPEND=""
RDEPEND=""

LICENSE="GPL-2"
IUSE=""
SLOT="0"

MODULE_NAMES="applespi(misc:${S})"


pkg_setup()
{
	CONFIG_CHECK="~SPI_PXA2XX ~MFD_INTEL_LPSS_SPI"
	[ "$PKG_SETUP_HAS_BEEN_RUN" ] && return 0
	get_version
	linux-mod_pkg_setup
	export PKG_SETUP_HAS_BEEN_RUN=yes
}
src_compile()
{
	local ARCH=x86

	emake \
		CC=$(tc-getCC) \
		LD=$(tc-getLD) \
		LDFLAGS="$(raw-ldflags)" \
		ARCH=$(tc-arch-kernel) \
		KVERSION="${KV_FULL}" \
		KDIR="${KV_OUT_DIR}"
}
src_install()
{
	linux-mod_src_install
}
