# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: x11-misc/tint2/tint2-9999.ebuild,v 1.7 2015/06/06 17:38:41 Exp $

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=subversion
	ESVN_REPO_URI="http://tint2.googlecode.com/svn/trunk/"
	SRC_URI="https://dl.dropbox.com/s/gmko5d6sy8qjpao/tint2patchfiles.tar.gz"
	;;
	(*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="http://tint2.googlecode.com/files/${MY_P}.tar.bz2"
	;;
esac
inherit eutils cmake-utils ${VCS_ECLASS}

DESCRIPTION="A lightweight panel/taskbar"
HOMEPAGE="http://code.google.com/p/tint2/"

LICENSE="GPL-2"
SLOT="0"
IUSE="battery examples tint2conf"

DEPEND="dev-libs/glib:2
	x11-libs/cairo
	x11-libs/pango[X]
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXdamage
	x11-libs/libXcomposite
	x11-libs/libXrender
	x11-libs/libXrandr
	media-libs/imlib2[X]
	virtual/pkgconfig
	x11-proto/xineramaproto"

RDEPEND="${COMMON_DEPEND}
	tint2conf? ( x11-misc/tintwizard )"

PATCHES=(
	"${WORKDIR}"/freespace.patch
	"${WORKDIR}"/launcher_apps_dir-v2.patch
	"${WORKDIR}"/src-task-align.patch
)

src_unpack()
{
	subversion_src_unpack
	unpack "${A}"
}

src_prepare()
{
	subversion_src_prepare
	cmake-utils_src_prepare
}

src_configure()
{
	local mycmakeargs=(
		$(cmake-utils_use_enable battery BATTERY)
		$(cmake-utils_use_enable examples EXAMPLES)
		$(cmake-utils_use_enable tint2conf TINT2CONF)

		# bug 296890
		"-DDOCDIR=/usr/share/doc/${PF}"
	)
	cmake-utils_src_configure
}

src_install()
{
	cmake-utils_src_install
	rm -f "${D}/usr/bin/tintwizard.py"
	dodoc
}

