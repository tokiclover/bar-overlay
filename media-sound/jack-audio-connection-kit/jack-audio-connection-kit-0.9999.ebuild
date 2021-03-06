# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

case "${PV}" in
	(*9999*)
		AUTOTOOLS_AUTORECONF=1
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/jackaudio/jack1.git"
		EGIT_HAS_SUBMODULES="example-clients jack tools"
		;;
	(*)
		KEYWORDS="~amd64 ~ppc ~x86"
		VCS_ECLASS=vcs-snapshot
		SRC_URI="https://github.com/jackaudio/jack1/archive/${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit eutils python-single-r1 autotools-multilib ${VCS_ECLASS}

DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/1"
IUSE="alsa celt coreaudio cpudetection doc debug examples oss netjack ieee1394 zalsa"

PPC_CPU_FLAGS=(altivec)
X86_CPU_FLAGS=(3dnow mmx sse)
IUSE="${IUSE} ${PPC_CPU_FLAGS[@]/#/cpu_flags_ppc_} ${X86_CPU_FLAGS[@]/#/cpu_flags_x86_}"
unset {PPC,X86}_CPU_FLAGS

RDEPEND=">=media-libs/libsndfile-1.0.0[${MULTILIB_USEDEP}]
	sys-libs/db:=[${MULTILIB_USEDEP}]
	sys-libs/ncurses:=[${MULTILIB_USEDEP}]
	celt? ( >=media-libs/celt-0.5.0[${MULTILIB_USEDEP}] )
	alsa? ( >=media-libs/alsa-lib-0.9.1[${MULTILIB_USEDEP}] )
	ieee1394? ( media-libs/libffado[${MULTILIB_USEDEP}] )
	netjack? ( media-libs/libsamplerate[${MULTILIB_USEDEP}] )
	zalsa? ( media-libs/zita-alsa-pcmi[${MULTILIB_USEDEP}]
		    media-libs/zita-resampler[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	app-portage/elt-patches
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	netjack? ( dev-util/scons )"

DOCS=( AUTHORS TODO README )

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
		$(use_enable alsa)
		$(use_enable coreaudio)
		$(use_enable debug)
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable oss)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable zalsa) 
		--disable-freebob
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
}

