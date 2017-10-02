# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-libs/elementary/elementary-1.17.0.ebuild,v 1.4 2016/04/04 Exp $

EAPI=5

case "${PV}" in
	(*9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://git.enlightenment.org/core/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	case "${PV}" in
		(*.9999*) EGIT_BRANCH="${PN}-${PV:0:4}";;
	esac
	AUTOTOOLS_AUTORECONF=1
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://download.enlightenment.org/rel/libs/${PN}/${P/_/-}.tar.xz"
	;;
esac
inherit autotools-multilib ${VCS_ECLASS}

RESTRICT="test"

DESCRIPTION="Basic widget set, based on EFL for mobile touch-screen devices"
HOMEPAGE="http://trac.enlightenment.org/e/wiki/Elementary"

LICENSE="LGPL-2.1"
SLOT="0/${PV:0:4}"
IUSE="X debug doc examples fbcon javascript +nls quicklaunch sdl static-libs
test wayland"

RDEPEND="
	=dev-libs/efl-${PV}*[X?,fbcon?,png,sdl?,wayland?,${MULTILIB_USEDEP}]
	javascript? ( net-libs/nodejs )
	nls? ( virtual/libintl[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	app-portage/elt-patches
	app-arch/xz-utils
	doc? ( app-doc/doxygen )
	test? ( >=dev-libs/check-0.9.5[${MULTILIB_USEDEP}] )"

S="${WORKDIR}/${P/_/-}"

multilib_src_configure()
{
	local -a myeconfargs=(
		${EXTRA_ELEMENTARY_CONF}
		$(use_enable X ecore-x)
		$(use_enable fbcon ecore-fb)
		$(use_enable javascript js-bindings)
		$(use_enable sdl ecore-sdl)
		$(use_enable wayland ecore-wl2)
		--disable-ecore-cocoa
		--disable-ecore-psl1ght
		--disable-ecore-win32
		$(use_enable debug)
		$(use_enable doc)
		$(use_enable examples build-examples)
		$(use_enable examples install-examples)
		$(use_enable nls)
		$(use_enable static-libs static)
		$(use_enable quicklaunch quick-launch)
		--with-tests=$(usex test regular none)
		--with-elementary-web-backend=none
	)
	autotools-utils_src_configure
}
