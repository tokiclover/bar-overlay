# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: dev-perl/perl-URxvt/perl-URxvt-9999.ebuild,v 1.2 2015/05/30 09:39:34 -tclover Exp $

EAPI=5

MY_PN="urxvt-perls"
MY_P="${MY_PN}-${PV}"

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

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/lib/urxvt/perl/
	doins clipboard keyboard-select url-select || die
	dodoc README.md
}
