# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: app-arch/lz4/lz4-9999.ebuild,v 1.12 2014/10/10 12:58:22 -tclover Exp $

EAPI=5

inherit multilib-minimal toolchain-funcs git-2

DESCRIPTION="Extremely Fast Compression algorithm"
HOMEPAGE="https://code.google.com/p/lz4/"
EGIT_REPO_URI="git://github.com/Cyan4973/lz4.git"
EGIT_COMMIT=r${PV}

LICENSE="BSD-2"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~s390 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="test valgrind"

DEPEND="test? ( valgrind? ( dev-util/valgrind ) )"

src_prepare()
{
	sed -e 's,sudo ,,g' -i {,lib/,programs/}Makefile
	if ! use valgrind; then
		sed -i -e '/^test:/s|test-mem||g' programs/Makefile || die
	fi
	multilib_copy_sources
}

multilib_src_compile()
{
	tc-export CC AR
	# we must not use the 'all' target since it builds test programs
	# & extra -m32 executables
	emake
	emake -C programs
}

multilib_src_install()
{
	emake install DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}"/usr/$(get_libdir)
}

