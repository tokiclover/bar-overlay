# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-misc/urxvt-perls/urxvt-perls-9999.ebuild v1.1 2012/07/04 00:21:38 -tclover Exp $

EAPI=2

inherit git

DESCRIPTION="Perl extensions for the rxvt-unicode terminal emulator"
HOMEPAGE="https://github.com/muennich/urxvt-perls"
EGIT_REPO_URI="git://github.com/muennich/urxvt-perls.git"
EGIT_PROJECT=${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
		x11-terms/rxvt-unicode"

src_install() {
	insinto /usr/lib/urxvt/perl/
	doins clipboard keyboard-select url-select || die "eek!"
	dodoc README.md
}
