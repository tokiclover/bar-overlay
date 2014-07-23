# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: virtual/liblash/liblash-1.ebuild, 2014/07/20 -tclover $

EAPI="5"

DESCRIPTION="Virtual for LASH library"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="python"

DEPEND=""
RDEPEND="|| ( media-sound/ladish[lash] media-sound/lash )
python? ( || ( media-sound/ladish[python] media-sound/lash[python] ) )"
