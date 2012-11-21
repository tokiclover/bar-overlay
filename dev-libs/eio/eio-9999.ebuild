# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/dev-libs/eio/eio-9999.ebuild,v 1.0 2012/11/21 19:56:29 -tclover Exp $

EAPI=2

inherit enlightenment

DESCRIPTION="Enlightenment's integration to IO"
HOMEPAGE="http://trac.enlightenment.org/e/wiki/EIO"
LICENSE="BSD"

IUSE="static-libs +threads"

RDEPEND=">=dev-libs/ecore-9999"
DEPEND="${RDEPEND}"

src_configure() {
	MY_ECONF="$(use_enable threads posix-threads)"
	enlightenment_src_configure
}
