# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-drivers/xf86-video-nouveau-9999.ebuild,v 1.0 2014/09/18 -tclover Exp $

EAPI=5

XORG_EAUTORECONF="yes"
XORG_DRI="always"

inherit linux-info xorg-2 git-2

EGIT_REPO_URI="git://anongit.freedesktop.org/git/nouveau/${PN}.git"
EGIT_COMMIT="${PN}-${PV}"


DESCRIPTION="Accelerated Open Source driver for nVidia cards"
HOMEPAGE="http://nouveau.freedesktop.org/"
SRC_URI=""

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/libdrm-2.4.34[video_cards_nouveau]"
DEPEND="${RDEPEND}"
