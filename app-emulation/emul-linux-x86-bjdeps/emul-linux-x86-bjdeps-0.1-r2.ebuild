# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/app-emulation/emul-linux-x86-bjdeps-0.1-r2.ebuild, v1.2 2011/11/05 -tclover Exp $

inherit libtool eutils flag-o-matic autotools multilib

DESCRIPTION="32bit nls-disabled dev-libs/popt-1.13"
HOMEPAGE="http://rpm5.org/"
# see bgo #129352
SRC_URI="http://rpm5.org/files/popt/popt-1.13.tar.gz"
RESTRICT="confcache"

WANT_AUTOMAKE="1.6"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND=""
RDEPEND=""
S="${WORKDIR}"/popt-1.13

pkg_setup() {
	multilib_toolchain_setup x86
}

src_prepare() {
	cd ${WORKDIR}
	mkdir ${P} # this way portage won't complain about missing directories

	cd "${S}" || die
	epatch "${FILESDIR}"/popt-1.12-scrub-lame-gettext.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
	# Don't install anything except the library itself
	rm -Rv "${D}"/usr/share || die
	rm -Rv "${D}"/usr/include || die
}

