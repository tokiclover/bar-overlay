# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-firmware/iucode-tool/iucode-tool-1.0.3.ebuild,v 1.1 2014/08/31 07:56:50 -tclover Exp $

EAPI=5

inherit autotools-utils git-2

DESCRIPTION="intel(r) 64 and IA-32 processor microcode tool"
HOMEPAGE="https://gitorious.org/iucode-tool/pages/Home"
EGIT_REPO_URI="git://gitorious.org:iucode-tool/iucode-tool.git"
EGIT_PROJECT=${PN}.git
EGIT_COMMIT=v${PV}

LICENSE="|| ( GPL-2 GPL-3)"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-util/valgrind )"
RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=( AUTHORS README NEWS TODO )

src_configure() {
	local myeconfargs=(
		$(use_enable test valgrind-build)
	)
	autotools-utils_src_configure
}
