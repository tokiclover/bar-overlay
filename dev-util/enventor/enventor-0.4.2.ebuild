# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-util/enventor/enventor-9999.ebuild,v 1.1 2015/02/02 12:02:10 -tclover Exp $

EAPI=5

inherit autotools-utils git-2

DESCRIPTION="EFL Dynamic EDC editor"
HOMEPAGE="https://enlightenment.org"
EGIT_REPO_URI="git://git.enlightenment.org/tools/${PN}.git"
EGIT_COMMIT=${PV}

IUSE=""
KEYWORDS="~amd64 ~x86"
LICENSE="BSD-2"
SLOT="0"

EFL_VERSION=1.12.0
RDEPEND=">=dev-libs/efl-${EFL_VERSION}
	>=media-libs/elementary-${EFL_VERSION}"
DEPEND="${RDEPEND}
	virtual/libintl"

DOCS=( AUTHORS NEWS README )

AUTOTOOLS_AUTORECONF=1
