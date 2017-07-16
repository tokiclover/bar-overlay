# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/deadbeef-plugins-spectogram/deadbeef-plugins-spectogram-9999.ebuild,v 1.1 2014/08/31 07:56:50 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/cboxdoerfer/ddb_musical_spectrum.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="spectrum plugin for DeaDBeeF audio player"
HOMEPAGE="https://github.com/cboxdoerfer/ddb_musical_spectrum"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gtk gtk3"

REQUIRED_USE="|| ( gtk gtk3 )"

DEPEND="sci-libs/fftw:3"
RDEPEND=">=media-sound/deadbeef-0.6.0[curl,gtk?,gtk3?]
	${DEPEND}"

src_compile() {
	use gtk && emake gtk2
	use gtk3 && emake gtk3
}

src_install() {
	insinto /usr/$(get_libdir)/deadbeef
	insopts -m0755
	doins gtk*/*.so
}
