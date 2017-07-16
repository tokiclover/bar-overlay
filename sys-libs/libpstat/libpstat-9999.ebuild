# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: sys-fs/libpstat/libpstat-9999.ebuild,v 1.0 2015/08/01 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/jcnelson/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~s390 ~x86 ~amd64-linux ~x86-linux"
		VCS_ECLASS=vcs-snapshot
		SRC_URI="https://github.com/jcnelson/${PN}/archive/r${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit multilib-minimal toolchain-funcs ${VCS_ECLASS}


DESCRIPTION="Virtual device manager for UNIX"
HOMEPAGE="https://github.com/jcnelson/libpstat"

LICENSE="|| ( ISC LGPL-3+ )"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=( README.md )
PATCHES=(
	"${FILESDIR}"/Makefile-DESTDIR.patch
)

src_prepare()
{
	export MAKEOPTS="-j1"
	epatch "${PATCHES[@]}"
	epatch_user
	multilib_copy_sources
}

multilib_src_install()
{
	emake DESTDIR="${ED}" PREFIX=/ LIBDIR="$(get_libdir)" \
		PKGCONFIGDIR="/usr/$(get_libdir)/pkgconfig" \
		INCLUDEDIR="/usr/include/pstat" install
}
