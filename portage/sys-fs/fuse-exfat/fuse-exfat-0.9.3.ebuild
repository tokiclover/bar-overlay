# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-fs/fuse-exfat-0.9.3.ebuld v 1.0 2011-03-10 $

inherit scons-utils

EAPI=3

DESCRIPTION="fuse implementation of the exfat filesystem"
HOMEPAGE="http://code.google.com/p/exfat/"
SRC_URI="http://exfat.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="sys-fs/fuse"
RDEPEND="sys-fs/fuse"

src_compile() {
	escons ${MAKEOPTS}
}

src_install() {
	DESTDIR="${D}"/sbin escons install || die "eek!"
	dodoc ChangeLog
}

