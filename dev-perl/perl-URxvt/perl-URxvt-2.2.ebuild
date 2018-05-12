# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://github.com/muennich/urxvt-perls.git"
	EGIT_PROJECT="${PN}.git"
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://github.com/muennich/urxvt-perls/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/urxvt-perls-${PV}"
	;;
esac
inherit eutils ${VCS_ECLASS}

DESCRIPTION="Perl extensions for the Rxvt-unicode terminal emulator"
HOMEPAGE="https://github.com/muennich/urxvt-perls"

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
