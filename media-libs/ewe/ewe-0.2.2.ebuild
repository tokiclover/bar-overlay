# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

RDEPEND="|| ( >=dev-libs/efl-1.18.0:=[${MULTILIB_USEDEP}]
	>=media-libs/elementary-1.12.2:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	app-portage/elt-patches"

DOCS=( AUTHORS ChangeLog NEWS README )

AUTOTOOLS_AUTORECONF=1
