# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-plugins/deadbeef-plugins-waveform/deadbeef-plugins-waveform-9999.ebuild,v 1.2 2015/08/16 07:56:50 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/cboxdoerfer/ddb_waveform_seekbar.git"
		EGIT_PROJECT="${PN}.git"
		AUTOTOOLS_AUTORECONF=1
		;;
	(*)
		KEYWORDS="~amd64 ~x86"
		VCS_ECLASS=vcs-snapshot
		SRC_URI="https://github.com/cboxdoerfer/ddb_waveform_seekbar/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="Waveform seekbar plugin for DeaDBeeF audio player"
HOMEPAGE="http://deadbeef-wf.sf.net https://github.com/cboxdoerfer/ddb_waveform_seekbar"

LICENSE="GPL-2"
SLOT="0"
IUSE="gtk gtk3"
REQUIRED_USE="|| ( gtk gtk3 )"

DEPEND="dev-db/sqlite:3"
RDEPEND=">=media-sound/deadbeef-0.6.0[curl,gtk?,gtk3?]
	${DEPEND}"

src_compile()
{
	use gtk && emake gtk2
	use gtk3 && emake gtk3
}

src_install()
{
	insinto /usr/$(get_libdir)/deadbeef
	insopts -m0755
	doins gtk*/ddb*.so
}
