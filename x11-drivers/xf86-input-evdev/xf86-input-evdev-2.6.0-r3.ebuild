# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $BAR-overlay/x11-drivers/xf86-input-evdev-2.6.3.ebuild,v 1.1 2011/11/12 -tclover Exp $

EAPI=3

HOMEPAGE="http://gitorious.org/at-home-modifier/pages/Home"
DESCRIPTION="Generic Linux input driver with at-home-modifier hack"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE=""
XORG_EAUTORECONF="yes"

if [[ ${PV} != 9999 ]]; then
	inherit xorg-2

	SRC_URI="${SRC_URI} https://gitorious.org/at-home-modifier/download/blobs/raw/master/patch/ahm-${PVR/0-r}.patch"
else
	inherit xorg-2 git-2
	GIT_ECLASS="git-2"
	EGIT_REPO_URI="git://gitorious.org/at-home-modifier/at-home-modifier.git"
fi

RDEPEND=">=x11-base/xorg-server-1.6.3"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6
	x11-proto/inputproto
	x11-proto/xproto"

src_prepare() {
	[[ ${PV} != 9999 ]] && epatch "${DISTDIR}"/ahm-${PVR/0-r}.patch
	xorg-2_src_prepare
}
