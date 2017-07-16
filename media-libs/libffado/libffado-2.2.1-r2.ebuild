# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-libs/libffado/libffado-2.2.1.ebuild,v 1.1 2014/12/12 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit base flag-o-matic scons-utils eutils toolchain-funcs multilib-minimal python-single-r1 udev

DESCRIPTION="Successor for freebob: Library for accessing BeBoB IEEE1394 devices"
HOMEPAGE="http://www.ffado.org"
SRC_URI="http://www.ffado.org/files/${P}.tgz"

DEFAULT_CARDS=( bebob fireworks oxford motu dice rme )
OTHER_CARDS=( metric_halo digidesign bounce )
FIREWIRE_CARDS=( "${DEFAULT_CARDS[@]}" "${OTHER_CARDS[@]}" )

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE="debug qt4 ${DEFAULT_CARDS[@]/#/+ffado_cards_} ${OTHER_CARDS[@]/#/ffado_cards_}"
REQUIRED_USE="${PYTHOH_REQUIRED_USE} || ( ${FIREWIRE_CARDS[@]/#/ffado_cards_} )"
unset {DEFAULT,OTHER}_CARDS

RDEPEND=">=dev-cpp/libxmlpp-2.6.13:2.6
	>=dev-libs/dbus-c++-0.9.0[${MULTILIB_USEDEP}]
	>=dev-libs/libconfig-1.4.8[${MULTILIB_USEDEP}]
	>=media-libs/alsa-lib-1.0.0[${MULTILIB_USEDEP}]
	>=media-libs/libiec61883-1.1.0[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1.0[${MULTILIB_USEDEP}]
	>=sys-libs/libraw1394-2.0.7[${MULTILIB_USEDEP}]
	>=sys-libs/libavc1394-0.5.3[${MULTILIB_USEDEP}]
	qt4? (
		dev-python/PyQt4[${PYTHON_USEDEP}]
		>=dev-python/dbus-python-0.83.0[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-jack-version.patch
)

src_prepare()
{
	base_src_prepare
	python_fix_shebang "${S}"
	multilib_copy_sources
}

multilib_src_configure()
{
	tc-export CC CXX
	[[ "$(tc-get-compiler-type)" = "gcc" ]] &&
	(( $(gcc-major-version 5) >= 5 )) &&
		append-cxxflags -std=c++11

	myesconsargs=(
		CC="${CC}"
		CXX="${CXX}"
		CFLAGS="${CFLAGS}"
		CXXFLAGS="${CXXFLAGS}"
		LDFLAGS="${LDFLAGS}"
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		MANDIR="${EPREFIX}/usr/share/man"
		UDEVDIR="$(get_udevdir)/udev/rules.d"
		PYPKGDIR="${EPREFIX}/usr/$(get_libdir)/python2.7/site-packages/${PN}"
		$(use_scons debug DEBUG)
		BUILD_TESTS=False
		# ENABLE_OPTIMIZATIONS detects cpu type and sets flags accordingly
		# -fomit-frame-pointer is added also which can cripple debugging.
		# we set flags from portage instead
		ENABLE_OPTIMIZATIONS=False
		CUSTOM_ENV=True
	)
	for card in "${FIREWIRE_CARDS[@]}"; do
		if use ffado_cards_${card} || has ${card} ${FFADO_CARDS}; then
			myesconsargs+=( "ENABLE_${card^^[a-z]}=${USE_SCONS_TRUE}" )
		else
			myesconsargs+=( "ENABLE_${card^^[a-z]}=${USE_SCONS_FALSE}" )
		fi
	done
	unset card
}

multilib_src_compile()
{
	escons "${myesconsargs[@]}"
}

multilib_src_install()
{
	escons DESTDIR="${D}" WILL_DEAL_WITH_XDG_MYSELF="True" install
}

multilib_src_install_all()
{
	python_optimize "${D}"

	if use qt4; then
		newicon "support/xdg/hi64-apps-ffado.png" "ffado.png"
		newmenu "support/xdg/ffado.org-ffadomixer.desktop" "ffado-mixer.desktop"
	fi
}

