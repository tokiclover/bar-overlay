# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-libs/elementary/elementary-1.13.0.ebuild,v 1.2 2015/02/12 -tclover Exp $

EAPI=5

inherit autotools-multilib

RESTRICT="test"

DESCRIPTION="Basic widget set, based on EFL for mobile touch-screen devices"
HOMEPAGE="http://trac.enlightenment.org/e/wiki/Elementary"
SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${P/_/-}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/${PV:0:4}"
KEYWORDS="~amd64 ~x86"
IUSE="X debug doc examples fbcon +nls quicklaunch sdl static-libs test wayland"

RDEPEND="
	>=dev-libs/efl-${PV:0:4}[X?,fbcon?,png,sdl?,wayland?,${MULTILIB_USEDEP}]
	nls? ( virtual/libintl[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
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
		$(use_enable sdl ecore-sdl)
		$(use_enable wayland ecore-wayland)
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
