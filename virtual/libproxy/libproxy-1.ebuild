# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: virtual/liblash/libproxy-1.ebuild,v 1.1 2014/12/01 20:54:56 Exp $

EAPI=5

inherit multilib-build

DESCRIPTION="Virtual for proxy library"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="|| ( net-libs/libproxy[${MULTILIB_USEDEP}]
	net-misc/pacrunner[libproxy,${MULTILIB_USEDEP}] )"
