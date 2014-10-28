# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/deadbeef-plugins-jack/deadbeef-plugins-jack-9999.ebuild,v 1.2 2014/10/10 14:30:08 -tclover Exp $

EAPI=5

inherit eutils git-2

DESCRIPTION="DeaDBeeF JACK output plugin"
HOMEPAGE="https://github.com/tokiclover/deadbeef-plugins-jack"
EGIT_REPO_URI="git://github.com/tokiclover/deadbeef-plugins-jack.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-sound/jack-audio-connection-kit"
RDEPEND="media-sound/deadbeef
	${DEPEND}"

DOCS=( BUGS README.md )

src_prepare()
{
	epatch_user
}

src_install()
{
	emake install \
		DESTDIR="${D}" LIBDIR="${EPREFIX}"/usr/$(get_libdir)/deadbeef
	dodoc "${DOCS[@]}"
}

