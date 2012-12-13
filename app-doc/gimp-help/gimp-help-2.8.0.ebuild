# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/app-doc/gimp-help/gimp-help-2.8.0.ebuild,v 1.1 2012/12/13 14:44:43 -tclover Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="GNU Image Manipulation Program help files"
HOMEPAGE="http://docs.gimp.org/"
SRC_URI="mirror://gimp/help/${P}.tar.bz2"

LICENSE="FDL-1.2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE="odf optimization nls pdf standalone"

LANGS="ca da de el en_GB es fi fr hr it ja ko lt nl nn pl ru sl sv zh_CN"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

DEPEND="dev-libs/libxslt
	dev-libs/libxml2
	odf? ( app-text/docbook2odf )
	optimization? ( || ( media-gfx/pngcrush media-gfx/pngnq ) )
	pdf? ( virtual/latex-base )"
RDEPEND="nls? ( sys-devel/gettext ) !standalone? ( >=media-gfx/gimp-2.6 )"

DOCS=( AUTHORS MAINTAINERS README )
BUILD_DIR="${S}"

src_prepare () {
	epatch "${FILESDIR}"/${P}-makefile.patch
	autotools-utils_src_prepare
}

src_configure () {
	use nls || export LINGUAS=""

	local myeconfargs=(
		$(use_with !standalone gimp)
	)
	autotools-utils_src_configure
}
