# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-libs/aubio/aubio-0.3.2-r2.ebuild,v 1.7 2015/02/10 18:03:32 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit eutils python-single-r1 waf-utils multilib-minimal

DESCRIPTION="Library for audio labelling"
HOMEPAGE="http://aubio.piem.org"
SRC_URI="http://aubio.piem.org/pub/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+alsa doc examples ffmpeg +jack +samplerate +sndfile static-libs"
REQUIRED_USE="${PYHON_REQUIRED_USE}"

RDEPEND="sci-libs/fftw:3.0[${MULTILIB_USEDEP}]
	${PYTHON_DEPS}
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	ffmpeg? ( virtual/ffmpeg[${MULTILIB_USEDEP}] )
	jack? ( media-sound/jack-audio-connection-kit[${MULTILIB_USEDEP}] )
	samplerate? ( media-libs/libsamplerate[${MULTILIB_USEDEP}] )
	sndfile? ( media-libs/libsndfile[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.0
	virtual/pkgconfig
	doc? ( app-doc/doxygen virtual/latex-base )"

DOCS=( AUTHORS ChangeLog README.md )

src_prepare()
{
	epatch_user
	python_fix_shebang python
	multilib_copy_sources
}

multilib_src_configure()
{
	local mywaffargs=(
		'--enable-fftw3f'
		$(use_enable static-libs static)
		$(use_enable jack)
		$(use_enable alsa)
		$(use_enable ffmpeg avcodec)
		$(use_enable samplerate)
		$(use_enable sndfile)
		"--with-target-platform=${CHOST}"
	)
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_configure "${mywafconfargs[@]}"
}

multilib_src_compile()
{
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_compile

	if multilib_is_native_abi && use doc; then
		export VARTEXFONTS="${T}/fonts"
		pushd doc > /dev/null 2>&1 || die
		doxygen full.cfg
		popd > /dev/null 2>&1 || die
	fi
}

multilib_src_install()
{
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_install

	if multilib_is_native_abi && use doc; then
		dohtml -r doc/full/html/*
	fi
}

multilib_src_install_all()
{
	rm -f -r "${ED}"/usr/share/doc/libaubio-doc
	use doc && dodoc doc/*.txt

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
		doins -r python/demos
		newdoc python/README README.python
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

