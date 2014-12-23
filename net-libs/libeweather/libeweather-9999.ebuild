# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-libs/libeweather/libeweather-9999.ebuild,v 1.2 2014/12/22 11:42:11 -tclover Exp $

EAPI=5

inherit autotools-multilib git-2

DESCRIPTION="Weather information fetching and parsing framework"
HOMEPAGE="https://enlightenment.org"
EGIT_REPO_URI="git://git.enlightenment.org/libs/libeweather.git"

IUSE=""
LICENSE="LGPL-2.1"
SLOT="0"

RDEPEND=">=dev-libs/efl-1.8[${MULTILIB_USEDEP}]"
RDEPEND=${DEPEND}

DOCS=( AUTHORS ChangeLog README )

AUTOTOOLS_AUTORECONF=1
