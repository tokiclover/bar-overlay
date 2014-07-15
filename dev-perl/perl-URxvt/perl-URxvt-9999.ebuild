# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-perl/perl-URxvt/perl-URxvt-9999.ebuild,v 1.1 2014/07/15 09:39:34 -tclover Exp $

EAPI="2"

inherit git-2

DESCRIPTION="A small collection of perl extensions for the rxvt-unicode terminal emulator"
HOMEPAGE="https://github.com/muennich/urxvt-perls"
EGIT_REPO_URI="git://github.com/muennich/urxvt-perls.git"
EGIT_PROJECT=${PN}.git

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	x11-terms/rxvt-unicode
	|| ( x11-misc/xsel x11-misc/xclip )"

src_install() {
	insinto /usr/lib/urxvt/perl/
	doins clipboard keyboard-select url-select || die
	dodoc README.md
}
