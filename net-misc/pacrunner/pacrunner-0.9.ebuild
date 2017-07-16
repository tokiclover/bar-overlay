# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: net-misc/pacrunner/pacrunner-9999.ebuild,v 1.2 2015/05/28 20:54:56 Exp $

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/network/connman/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	AUTOTOOLS_AUTORECONF=1
	AUTOTOOLS_IN_SOURCE_BUILD=1
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
	SRC_URI="https://www.kernel.org/pub/linux/network/connman/${P}.tar.xz"
	;;
esac
inherit autotools-multilib ${VCS_ECLASS}

DESCRIPTION="Proxy configuration daemon"
HOMEPAGE="https://01.org/connman/"

LICENSE="GPL-2 libproxy? ( LGPL-2.1 )"
SLOT="0"
IUSE="curl debug hardened libproxy test"

DEPEND=">=sys-apps/dbus-1.2[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.16[${MULTILIB_USEDEP}]
	curl? ( >=net-misc/curl-7.16[${MULTILIB_USEDEP}] )
	libproxy? ( !net-libs/libproxy )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog HACKING README TODO )

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

