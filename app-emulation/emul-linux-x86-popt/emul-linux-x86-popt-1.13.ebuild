# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: app-emulation/emul-linux-x86-bjdeps/emul-linux-x86-popt-1.13.ebuild v1.1 2012/05/30 -tclover Exp $

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
	cd ${WORKDIR}
	mkdir ${P} # this way portage won't complain about missing directories

	cd "${S}" || die
	epatch "${FILESDIR}"/popt-1.12-scrub-lame-gettext.patch
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die
	# Don't install anything except the library itself
	rm -Rv "${D}"/usr/share || die
	rm -Rv "${D}"/usr/include || die
}
