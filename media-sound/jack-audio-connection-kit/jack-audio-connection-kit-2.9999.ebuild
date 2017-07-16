# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/jack-audio-connection-kit-2.9999.ebuild,v 1.2 2015/06/08 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/jackaudio/jack2.git"
		;;
	(*)
		KEYWORDS="~amd64 ~ppc ~x86"
		VCS_ECLASS=vcs-snapshot
		SRC_URI="https://github.com/jackaudio/jack2/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit eutils python-single-r1 waf-utils multilib-minimal ${VCS_ECLASS}

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://jackaudio.org/"

LICENSE="GPL-2"
SLOT="0/${PV:0:1}"
IUSE="alsa celt debug doc dbus ieee1394 opus pam"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="media-libs/libsamplerate[${MULTILIB_USEDEP}]
	>=media-libs/libsndfile-1.0.0[${MULTILIB_USEDEP}]
	${PYTHON_DEPS}
	alsa? ( >=media-libs/alsa-lib-1.0.24[${MULTILIB_USEDEP}] )
	celt? ( media-libs/celt[${MULTILIB_USEDEP}] )
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	ieee1394? ( media-libs/libffado[${MULTILIB_USEDEP}] )
	opus? ( media-libs/opus[custom-modes,${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${RDEPEND}
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	pam? ( sys-auth/realtime-base )"

DOCS=( ChangeLog README README_NETJACK2 TODO )

src_prepare()
{
	base_src_prepare
	multilib_copy_sources
}

multilib_src_configure()
{
	local -a mywafconfargs=(
		${EXTRA_JACK_CONF}
		$(usex alsa --alsa "")
		$(usex dbus --dbus --classic)
		$(usex debug --debug "")
		$(usex ieee1394 --firewire "")
	)
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_configure "${mywafconfargs[@]}"
}

multilib_src_compile()
{
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_compile

	if multilib_is_native_abi && use doc; then
		doxygen || die "doxygen failed"
	fi
}

multilib_src_install()
{
	WAF_BINARY="${BUILD_DIR}"/waf waf-utils_src_install

	multilib_is_native_abi && use doc && dohtml -r html/*
}

multilib_src_install_all()
{
	python_fix_shebang "${ED}"
}

