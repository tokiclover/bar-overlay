# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/deadbeef-plugins-jack/deadbeef-plugins-jack-0.3.ebuild,v 1.2 2014/10/10 14:30:08 -tclover Exp $

EAPI=5

inherit eutils

DESCRIPTION="DeaDBeeF JACK output plugin"
HOMEPAGE="https://github.com/tokiclover/deadbeef-plugins-jack"
SRC_URI="https://github.com/tokiclover/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-sound/jack-audio-connection-kit"
RDEPEND="media-sound/deadbeef
	${DEPEND}"

src_prepare()
{
	epatch_user
}

src_install()
{
	emake install \
		DESTDIR="${D}" LIBDIR="${EPREFIX}"/usr/$(get_libdir)/deadbeef
}

