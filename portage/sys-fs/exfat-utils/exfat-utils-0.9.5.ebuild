# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit scons-utils

EAPI=3

DESCRIPTION="exFAT filesystem utilities."
HOMEPAGE="http://code.google.com/p/exfat/"
SRC_URI="http://exfat.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="sys-fs/fuse"
RDEPEND="sys-fs/fuse
	sys-fs/fuse-exfat"

src_compile() {
	escons ${MAKEOPTS}
}

src_install() {
	escons DESTDIR="${D}"/sbin install || die "eek!"
	dodoc ChangeLog
}

