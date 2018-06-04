# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://gitlab.com/o9000/tint2.git"
	;;
	(*)
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://gitlab.com/o9000/${PN}/repository/archive.tar.gz?ref=v${PV} -> ${P}.tar.gz"
	;;
esac
inherit cmake-utils gnome-utils vcs-snapshot ${VCS_ECLASS}

DESCRIPTION="tint2 is a lightweight panel/taskbar for Linux"
HOMEPAGE="https://gitlab.com/o9000/tint2"

LICENSE="GPL-2"
SLOT="0"
IUSE="battery svg startup-notification tint2conf"

RDEPEND="dev-libs/glib:2
	svg? ( gnome-base/librsvg )
	>=media-libs/imlib2-1.4.2[X,png]
	x11-libs/cairo
	tint2conf? ( x11-libs/gtk+:2 )
	x11-libs/pango[X]
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXdamage
	>=x11-libs/libXrandr-1.3
	x11-libs/libXrender
	startup-notification? ( x11-libs/startup-notification )
	x11-proto/xineramaproto"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure()
{
	local mycmakeargs=(
		${EXTRA_TINT2_CONF}
		$(cmake-utils_use_enable battery BATTERY)
		$(cmake-utils_use_enable svg RSVG)
		$(cmake-utils_use_enable startup-notification SN)
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

