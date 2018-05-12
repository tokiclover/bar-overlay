# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib-build

DESCRIPTION="Virtual for LASH library"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="python"

DEPEND=""
RDEPEND="|| ( media-sound/ladish[lash,python?] media-sound/lash[python?] )"
