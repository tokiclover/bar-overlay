# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-libs/dbus-c++/dbus-c++-0.9.0-r1.ebuild,v 1.2 2014/12/14 08:25:42 -tclover Exp $

EAPI=5

inherit autotools-multilib

DESCRIPTION="provide a C++ API for D-BUS"
HOMEPAGE="http://sourceforge.net/projects/dbus-cplusplus/ http://sourceforge.net/apps/mediawiki/dbus-cplusplus/index.php?title=Main_Page"
SRC_URI="mirror://sourceforge/dbus-cplusplus/lib${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="doc ecore glib static-libs test"

RDEPEND="sys-apps/dbus[${MULTILIB_USEDEP}]
	ecore? ( dev-libs/ecore )
	glib? ( dev-libs/glib[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	dev-util/cppunit
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README TODO )

PATCHES=(
	#424707
	"${FILESDIR}"/${P}-gcc-4.7.patch
)

S="${WORKDIR}/lib${P}"

AUTOTOOLS_IN_SOURCE_BUILD=1

multilib_src_configure()
{
	local -a myeconfargs=(
		--disable-examples
		$(use_enable doc doxygen-docs)
		$(use_enable ecore)
		$(use_enable glib)
		$(use_enable static-libs static)
		$(use_enable test tests)
	)
	ECONF_SOURCE="${BUILD_DIR}" autotools-utils_src_configure
}
