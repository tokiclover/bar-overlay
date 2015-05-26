# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-util/enventor/enventor-0.5.0.ebuild,v 1.1 2015/05/26 12:02:10 -tclover Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="EFL Dynamic EDC editor"
HOMEPAGE="https://enlightenment.org"
SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz"

IUSE=""
KEYWORDS="~amd64 ~x86"
LICENSE="BSD-2"
SLOT="0"

EFL_VERSION=1.13.0
RDEPEND=">=dev-libs/efl-${EFL_VERSION}
	>=media-libs/elementary-${EFL_VERSION}"
DEPEND="${RDEPEND}
	virtual/libintl"

DOCS=( AUTHORS NEWS README )
