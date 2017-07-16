# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: sys-apps/less/less-9999.ebuild,v 1.8 2014/07/14 05:20:34 Exp $

EAPI="4"

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/andikleen/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
		SRC_URI="http://www.greenwoodsoftware.com/less/${P}.tar.gz"
		;;
esac
inherit eutils ${VCS_ECLASS}

CODE2COLOR_PV="0.2"
CODE2COLOR_P="code2color-${CODE2COLOR_PV}"
# See http://halobates.de/blog/p/293 for optimizations info

DESCRIPTION="Excellent text file viewer"
HOMEPAGE="https://github.com/andikleen/less http://www.greenwoodsoftware.com/less/"
SRC_URI+="
	http://www-zeuthen.desy.de/~friebel/unix/less/code2color -> ${CODE2COLOR_P}"

LICENSE="|| ( GPL-3 BSD-2 )"
SLOT="0"
IUSE="pcre unicode"

DEPEND=">=app-misc/editor-wrapper-3
	>=sys-libs/ncurses-5.2
	pcre? ( dev-libs/libpcre )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${CODE2COLOR_P}.patch
)

src_prepare()
{
	cp "${DISTDIR}"/${CODE2COLOR_P} "${S}"/code2color || die
	epatch "${PATCHES[@]}"
	epatch_user
}

src_configure()
{
	export ac_cv_lib_ncursesw_initscr=$(usex unicode)
	export ac_cv_lib_ncurses_initscr=$(usex !unicode)
	econf \
		--with-regex=$(usex pcre pcre posix) \
		--with-editor="${EPREFIX}"/usr/libexec/editor
}

src_install()
{
	default

	dobin code2color
	newbin "${FILESDIR}"/lesspipe.sh lesspipe
	dosym lesspipe /usr/bin/lesspipe.sh
	newenvd "${FILESDIR}"/less.envd 70less

	dodoc "${FILESDIR}"/README.Gentoo
}

pkg_postinst()
{
	elog "lesspipe offers colorization options.  Run 'lesspipe -h' for info."
}
