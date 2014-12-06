# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-misc/pacrunner/pacrunner-9999.ebuild,v 1.1 2014/12/01 20:54:56 -tclover Exp $

EAPI=5

inherit autotools-multilib git-2

DESCRIPTION="Proxy configuration daemon"
HOMEPAGE="https://01.org/connman/"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/network/connman/${PN}.git"
EGIT_COMMIT=${PV}

LICENSE="GPL-2 libproxy? ( LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl debug hardened libproxy test"

DEPEND=">=sys-apps/dbus-1.2[${MULTILIB_USEDEP}]
	curl? ( >=net-misc/curl-7.16[${MULTILIB_USEDEP}] )
	libproxy? ( !net-libs/libproxy )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog HACKING README TODO )

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

multilib_src_configure()
{
	local -a myeconfargs=(
		${EXTRA_CONF}
		$(use_enable curl)
		$(use_enable debug)
		$(use_enable hardened pie)
		$(use_enable libproxy)
		$(use_enable test)
	)
	ECONF_SOURCE="${BUILD_DIR}" autotools-utils_src_configure "${myeconfargs[@]}"
}

