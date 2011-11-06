# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/app-emulation/emul-linux-x86-bjdeps-0.1-r2.ebuild, v1.1 2011/11/05 -tclover Exp $

inherit libtool eutils flag-o-matic autotools multilib

DESCRIPTION="32bit nls-disabled dev-libs/popt-1.13"
HOMEPAGE="http://rpm5.org/"
# see #129352
SRC_URI="http://rpm5.org/files/popt/popt-1.13.tar.gz"
RESTRICT="confcache"

WANT_AUTOMAKE="1.6"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
DEPEND=""
RDEPEND=""

pkg_setup() {
	export ABI=x86
}

src_unpack() {
	unpack ${A}

	cd ${WORKDIR}
	mkdir ${P} # this way portage won't complain about missing directories

	cd "${WORKDIR}/popt-1.13" || die
	epatch "${FILESDIR}"/popt-1.12-scrub-lame-gettext.patch
}

src_compile() {
	cd "${WORKDIR}/popt-1.13" || die
	econf "--libdir=/usr/lib32" || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	cd "${WORKDIR}/popt-1.13" || die
	emake install DESTDIR="${D}" || die
	# Don't install anything except the library itself
	rm -Rv ${D}/usr/share || die
	rm -Rv ${D}/usr/include || die
}

