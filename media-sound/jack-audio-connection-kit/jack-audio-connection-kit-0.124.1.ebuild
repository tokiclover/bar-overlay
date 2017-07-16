# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/jack-audio-connection-kit-1.9999.ebuild,v 1.2 2015/06/08 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

case "${PV}" in
	(*9999*)
		AUTOTOOLS_AUTORECONF=1
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/jackaudio/jack1.git"
		EGIT_HAS_SUBMODULES="example-clients jack"
		;;
	(*)
		KEYWORDS="~amd64 ~ppc ~x86"
		VCS_ECLASS=vcs-snapshot
		SRC_URI="https://github.com/jackaudio/jack1/archive/${PV/_/}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit eutils python-single-r1 autotools-multilib ${VCS_ECLASS}

DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/1"
IUSE="alsa celt coreaudio cpudetection doc debug examples oss netjack freebob ieee1394 zalsa"
REQUIRED_USE="freebob? ( !ieee1394 ) ieee1394? ( !freebob )"

PPC_CPU_FLAGS=(altivec)
X86_CPU_FLAGS=(3dnow mmx sse)
IUSE="${IUSE} ${PPC_CPU_FLAGS[@]/#/cpu_flags_ppc_} ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_}"
unset {PPC,X86}_CPU_FLAGS

RDEPEND=">=media-libs/libsndfile-1.0.0[${MULTILIB_USEDEP}]
	${PYTHON_DEPS}
	sys-libs/db:=[${MULTILIB_USEDEP}]
	sys-libs/ncurses:=[${MULTILIB_USEDEP}]
	celt? ( >=media-libs/celt-0.5.0[${MULTILIB_USEDEP}] )
	alsa? ( >=media-libs/alsa-lib-0.9.1[${MULTILIB_USEDEP}] )
	freebob? ( sys-libs/libfreebob[${MULTILIB_USEDEP}] )
	ieee1394? ( media-libs/libffado[${MULTILIB_USEDEP}] )
	netjack? ( media-libs/libsamplerate[${MULTILIB_USEDEP}] )
	zalsa? ( media-libs/zita-alsa-pcmi[${MULTILIB_USEDEP}]
		    media-libs/zita-resampler[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	netjack? ( dev-util/scons )"

DOCS=( AUTHORS TODO README )

PATCHES=(
	"${FILESDIR}"/${PN}-0.121.3-sparc-cpuinfo.patch
	"${FILESDIR}"/${PN}-0.121.3-freebsd.patch
)

src_prepare()
{
	autotools-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure()
{
	local -a myconfargs=(${EXTRA_JACK_CONF})

	# CPU Detection (dynsimd) uses asm routines which requires 3dnow, mmx and sse.
	if use cpudetection && use cpu_flags_x86_3dnow && use cpu_flags_x86_mmx &&
		use cpu_flags_x86_sse; then
		einfo "Enabling cpudetection (dynsimd)"
		myconfargs=(--enable-dynsimd)
	fi
	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	myeconfargs+=(
		$(use_enable ieee1394 firewire)
		$(use_enable freebob)
		$(use_enable alsa)
		$(use_enable coreaudio)
		$(use_enable debug)
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable oss)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable zalsa) 
		--disable-dependency-tracking
		--with-default-tmpdir=/dev/shm
		--with-html-dir=/usr/share/doc/${PF}
	)
	autotools-utils_src_configure
}

multilib_src_install()
{
	autotools-utils_src_install
}

multilib_src_install_all()
{
	use examples && dodoc -r example-clients
	python_fix_shebang "${ED}"
}

