# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: app-emulation/emul-linux-x86-bjdeps/emul-linux-x86-popt-1.16.ebuild v1.1 2012/07/04 00:20:29 -tclover Exp $

inherit libtool eutils flag-o-matic autotools multilib

DESCRIPTION="32bit nls-disabled dev-libs/${P#*-x86-}"
HOMEPAGE="http://rpm5.org/"
SRC_URI="http://rpm5.org/files/popt/${P#*-x86-}.tar.gz"
RESTRICT="confcache"

WANT_AUTOMAKE="1.6"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static-libs"
DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${P#*-x86-}

pkg_setup() {
	multilib_toolchain_setup x86
}

src_prepare() {
	epatch "${FILESDIR}"/fix-popt-pkgconfig-libdir.patch #349558
	sed -i -e 's:lt-test1:test1:' testit.sh || die
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die

	rm -Rv "${D}"//usr/lib/pkgconfig
	rm -Rv "${D}"/usr/share || die
	rm -Rv "${D}"/usr/include || die

	find "${ED}" -name '*.la' -exec rm -f {} +
}
