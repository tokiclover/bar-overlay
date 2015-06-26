# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-firmware/iucode-tool/iucode-tool-1.3.ebuild,v 1.2 2015/06/26 07:56:50 -tclover Exp $

EAPI=5

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		AUTOTOOLS_AUTORECONF=1
		AUTOTOOLS_IN_SOURCE_BUILD=1
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="https://gitlab.com/${PN}/releases/raw/871cfe4695eeff3ffe8b633aad3e14af3c908af1/${PN}_${PV}.tar.xz -> ${P}.tar.xz"
		S="${WORKDIR}/${PN/-/_}-${PV}"
		;;
esac
inherit autotools-utils ${VCS_ECLASS}

DESCRIPTION="intel(r) 64 and IA-32 processor microcode tool"
HOMEPAGE="https://gitlab.com/groups/iucode-tool"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
IUSE="test"

DEPEND="test? ( dev-util/valgrind )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README NEWS TODO )

src_configure()
{
	local -a myeconfargs=( ${EXTRA_IUCODE_CONF}
		$(use_enable test valgrind-build)
	)
	autotools-utils_src_configure
}
