# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-plugins/deadbeef-plugins-jack/deadbeef-plugins-jack-9999.ebuild,v 1.1 2012/11/10 14:43:14 -tclover Exp $

EAPI=4

inherit eutils git-2

DESCRIPTION="Headphone crossfeed plugin using libbs2b"
HOMEPAGE="http://gitorious.org/deadbeef-sm-plugins/pages/Home"
EGIT_REPO_URI="git://gitorious.org/deadbeef-sm-plugins/bs2b.git"
EGIT_PROJECT=${PN}.git

LICENSE="AS-IS"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/libbs2b"
RDEPEND="media-sound/deadbeef
	${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/Makefile.patch
	export LDFLAGS="${LDFLAGS//--as-needed/--no-as-needed}"
}
src_install() {
	insinto /usr/$(get_libdir)/deadbeef
	doins bs2b.so
}
