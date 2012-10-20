# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-plugins/deadbeef-plugins-archive/deadbeef-plugins-archive-9999.ebuild,v 1.1 2012/10/20 13:03:32 -tclover Exp $

EAPI=4

inherit eutils git-2

DESCRIPTION="Headphone crossfeed plugin using libbs2b"
HOMEPAGE="http://gitorious.org/deadbeef-sm-plugins/pages/Home"
EGIT_REPO_URI="git://gitorious.org/deadbeef-sm-plugins/bs2b.git"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libbs2b"
RDEPEND="media-sound/deadbeef
	${DEPEND}"

src_install() {
	insinto /usr/$(get_libdir)/deadbeef
	doins bs2b.so
}
