# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-libs/aubio/aubio-0.3.2-r2.ebuild,v 1.6 2014/10/10 18:03:32 -tclover Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 autotools-multilib

DESCRIPTION="Library for audio labelling"
HOMEPAGE="http://aubio.piem.org"
SRC_URI="http://aubio.piem.org/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa doc examples jack lash static-libs"

RDEPEND="sci-libs/fftw:3.0[${MULTILIB_USEDEP}]
	media-libs/libsndfile[${MULTILIB_USEDEP}]
	media-libs/libsamplerate[${MULTILIB_USEDEP}]
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	jack? ( media-sound/jack-audio-connection-kit[${MULTILIB_USEDEP}] )
	lash? ( virtual/liblash[${MULTILIB_USEDEP}] )"

DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.0
	virtual/pkgconfig
	doc? ( app-doc/doxygen virtual/latex-base )"

DOCS=( AUTHORS ChangeLog README TODO )

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-numarray-gnuplot.patch
	"${FILESDIR}"/${P}-libm.patch
)

ATOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=modules

src_prepare()
{
	# disable automagic puredata wrt #369835
	sed -i -e '/AC_CHECK_HEADER/s:m_pd.h:dIsAbLe&:' configure.ac || die

	python_fix_shebang python
	autotools-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure()
{
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable jack)
		$(use_enable alsa)
		$(use_enable lash)
	)
	ECONF_SOURCE="${BUILD_DIR}" autotools-utils_src_configure
}

multilib_src_compile()
{
	autotools-utils_src_compile

	if multilib_is_native_abi && use doc; then
		export VARTEXFONTS="${T}/fonts"
		pushd doc > /dev/null 2>&1 || die
		doxygen user.cfg
		doxygen devel.cfg
		doxygen examples.cfg
		popd > /dev/null 2>&1 || die
	fi
}

multilib_src_install()
{
	autotools-utils_src_install

	multilib_is_native_abi || return 0

	doman doc/*.1
	if use doc; then
		mv doc/user/html doc/user/user
		dohtml -r doc/user/user
		mv doc/devel/html doc/devel/devel
		dohtml -r doc/devel/devel
		mv doc/examples/html doc/examples/examples
		dohtml -r doc/examples/examples
	fi
}

multilib_src_install_all()
{
	if use examples; then
		# install dist_noinst_SCRIPTS from Makefile.am
		insinto /usr/share/doc/${PF}/examples
		doins python/aubio{compare-onset,plot-notes,filter-notes,web.py}
		docinto examples
		newdoc python/README README.examples
	fi
}

pkg_postinst()
{
	python_mod_optimize aubio
}
pkg_postrm()
{
	python_mod_cleanup aubio
}

