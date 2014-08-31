# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/deadbeef-plugins-waveform/deadbeef-plugins-waveform-9999.ebuild,v 1.1 2014/08/31 07:56:50 -tclover Exp $

EAPI=5

inherit eutils git-2

DESCRIPTION="waveform seekbar plugin for DeaDBeeF audio player"
HOMEPAGE="https://github.com/cboxdoerfer/ddb_waveform_seekbar"
EGIT_REPO_URI="git://github.com/cboxdoerfer/ddb_waveform_seekbar.git"
EGIT_PROJECT=${PN}.git

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gtk gtk3"

REQUIRED_USE="|| ( gtk gtk3 )"

DEPEND="dev-db/sqlite:3"
RDEPEND=">=media-sound/deadbeef-0.6.0[curl,gtk?,gtk3?]
	${DEPEND}"

src_compile() {
	use gtk && emake gtk2
	use gtk3 && emake gtk3
}

src_install() {
	insinto /usr/$(get_libdir)/deadbeef
	insopts -m0755
	doins ddb_misc_waveform_GTK*.so
}
