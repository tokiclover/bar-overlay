# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: sys-process/runit/runit-2.1.1-r1.ebuild,v 1.13 2015/06/18 19:18:50 Exp $

EAPI=3

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://smarden.org/git/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
		SRC_URI="http://smarden.org/${PN}/${P}.tar.gz"
		;;
esac
inherit eutils toolchain-funcs flag-o-matic ${VCS_ECLASS}

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://smarden.org/runit/"

LICENSE="BSD-2"
SLOT="0"
IUSE="doc static +scripts"

RDEPEND="scripts? ( sys-process/supervision )"

S=${WORKDIR}/admin/${P}/src
PATCHES=(
	"${FILESDIR}/${PN}-2.1-runsv-logdir.patch"
	"${FILESDIR}/${PN}-2.1-sv-check.patch"
)

src_prepare()
{
	epatch "${PATCHES[@]}"
	epatch_user
	# we either build everything or nothing static
	sed -i -e 's:-static: :' Makefile
}

src_configure()
{
	use static && append-ldflags -static

	echo "$(tc-getCC) ${CFLAGS}"  > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
}

src_install()
{
	dobin $(<../package/commands) || die "dobin"
	dodir /{,s}bin
	mv "${ED}"/usr/bin/{runit-init,runit,utmpset} "${ED}"/sbin/ || die "dosbin"
	mv "${ED}"/usr/bin/{chpst,runsv{,{,ch}dir},sv{,logd}} "${ED}"/bin/ || die "dobin"

	cd "${S}"/..
	dodoc package/{CHANGES,README,THANKS,TODO}
	use doc && dohtml doc/*.html
	doman man/*.[18]
}
