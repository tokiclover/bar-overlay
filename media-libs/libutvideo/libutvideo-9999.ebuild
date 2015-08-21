# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-libs/libutvideo/libutvideo-15.2.0.ebuild,v 1.1 2015/01/01 -tclover Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/qyot27/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
		SRC_URI="https://github.com/qyot27/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit eutils flag-o-matic multilib multilib-minimal toolchain-funcs ${VCS_ECLASS}

DESCRIPTION="Ut Video multi-interface lossless Video Codec"
HOMEPAGE="https://github.com/qyot27/libutvideo"
#SRC_URI+="
#	https://raw.githubusercontent.com/qyot27/libutvideo/buildsystem/GNUmakefile -> ${PN}-15.1.0-Makefile
#	https://raw.githubusercontent.com/qyot27/libutvideo/buildsystem/configure -> ${PN}-15.1.0-configure
#	https://raw.githubusercontent.com/qyot27/libutvideo/buildsystem/config.gess -> ${PN}-15.1.0-config.gess
#	https://raw.githubusercontent.com/qyot27/libutvideo/buildsystem/config.sub -> ${PN}-15.1.0-config.sub"

LICENSE="GPL-2+"
SLOT="0"
IUSE="debug +pic static-libs"
REQUIRED_USE="!static-libs? ( pic )"

ASM_DEPEND="static-libs? ( dev-lang/nasm )"
DEPEND="amd64? ( ${ASM_DEPEND} )
	x86? ( ${ASM_DEPEND} )"
RDEPEND=""

DOCS=( readme.en.html )

src_prepare()
{
	cp -a "${FILESDIR}"/config{ure,.guess,.sub} . || die
	cp -a "${FILESDIR}"/GNUmakefile Makefile || die
	epatch_user
	multilib_copy_sources
}

multilib_src_configure()
{
	tc-export CC CXX AR RANLIB STRIP

	local ASM
	case "${ABI}" in
		(x86|amd86) ASM="$(use_enable static-libs asm)";;
		(*) ASM="--disable-asm";;
	esac
	local -a myeconfargs=(
		${EXTRA_UTVIDEO_CONF}
		${ASM}
		--cross-prefix=${CHOST}
		$(usex static-libs '--disable-shared' '--enable-shared')
		$(use_enable debug)
		$(use_enable pic)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

multilib_src_install()
{
	emake DESTDIR="${ED}" includedir=/usr/include \
		libdir=/usr/$(get_libdir) prefix=/usr install
}
