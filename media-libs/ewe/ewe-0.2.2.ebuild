# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-libs/ewe/ewe-9999.ebuild,v 1.2 2014/12/22 12:02:10 Exp $

EAPI=5

inherit autotools-multilib git-2

DESCRIPTION="Elementary Widgets Extension, desktop widget library"
HOMEPAGE="https://enlightenment.org"
EGIT_REPO_URI="git://git.enlightenment.org/devs/rimmed/${PN}.git"
EGIT_COMMIT=${PV}

IUSE=""
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2"
SLOT="0"

RDEPEND=">=dev-libs/efl-1.12.2:=[${MULTILIB_USEDEP}]
	>=media-libs/elementary-1.12.2:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )

AUTOTOOLS_AUTORECONF=1
