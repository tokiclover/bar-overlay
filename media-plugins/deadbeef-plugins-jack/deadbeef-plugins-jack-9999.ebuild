# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/deadbeef-plugins-jack/deadbeef-plugins-jack-9999.ebuild,v 1.2 2014/08/16 14:30:08 -tclover Exp $

EAPI=5

inherit eutils git-2

DESCRIPTION="Headphone crossfeed plugin using libbs2b"
HOMEPAGE="http://gitorious.org/deadbeef-sm-plugins/pages/Home"
EGIT_REPO_URI="git://gitorious.org/deadbeef-sm-plugins/jack.git"
EGIT_PROJECT=${PN}.git

LICENSE="BSD-1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-sound/jack-audio-connection-kit"
RDEPEND="media-sound/deadbeef
	${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/Makefile.patch
	filter-ldflags "--as-needed"
	append-ldflags "--no-as-needed"
}

src_install() {
	EXEOPTIONS="-m0755"
	exeinto /usr/$(get_libdir)/deadbeef
	doexe jack.so
}
