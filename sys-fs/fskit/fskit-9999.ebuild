# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-fs/fskit/fskit-9999.ebuild,v 1.1 2015/10/01 Exp $

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


DESCRIPTION="Filesystem utility library and SDK"
HOMEPAGE="https://github.com/jcnelson/fskit"

LICENSE="|| ( ISC LGPL-3+ )"
SLOT="0"
IUSE="fuse"

DEPEND="fuse? ( sys-fs/fuse )"
RDEPEND="${DEPEND}"

DOCS=( CONTRIBUTORS README.md )

src_prepare()
{
	epatch_user
	multilib_copy_sources
}

multilib_src_compile()
{
	MAKEOPTS="-j1" emake
	use fuse && MAKEOPTS="-j1" emake -C fuse
}

multilib_src_install()
{
	emake DESTDIR="${ED}" PREFIX=/usr LIBDIR="${ED}/$(get_libdir)" \
		PKGCONFIGDIR="${ED}/usr/$(get_libdir)/pkgconfig" install
	use fuse && \
		emake -C fuse DESTDIR="${ED}" PREFIX=/usr LIBDIR="${ED}/$(get_libdir)" \
		PKGCONFIGDIR="${ED}/usr/$(get_libdir)/pkgconfig" install

}
