# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-wm/enlightenment/enlightenment-0.18.9999.ebuild,v 1.2 2015/05/20 Exp $

EAPI=5
PLOCALES="bg ca cs da de el eo es fi fr fr_CH he hu it ja ko nb nl pl pt_BR ru sk sl sv tr zh_CN zh_TW"

case "${PV}" in
	(*9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://git.enlightenment.org/core/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	case "${PV}" in
		(*.9999*) EGIT_BRANCH="${PN}-${PV:0:4}";;
	esac
	AUTOTOOLS_AUTORECONF=1
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P/_/-}.tar.bz2"
	;;
esac
inherit l10n autotools-utils ${VCS_ECLASS}

DESCRIPTION="Enlightenment DR${PV:2:4} window manager"
HOMEPAGE="http://www.enlightenment.org/"

LICENSE="BSD-2"
SLOT="0.17/${PV:0:4}"

E_MODULES_DEFAULT=(
	conf-applications conf-bindings conf-dialogs conf-display conf-interaction
	conf-intl conf-menus conf-paths conf-performance conf-randr conf-shelves
	conf-theme conf-window-manipulation conf-window-remembers

	appmenu backlight battery bluez4 clock connman contact cpufreq everything
	fileman fileman-opinfo gadman ibar ibox lokker mixer msgbus music-control
	notification pager pager16 quickaccess shot start syscon systray tasks
	teamwork temperature tiling winlist wizard xkbswitch
)
E_MODULES=(
	access packagkit wl-desktop-shell wl-drm wl-fb wl-x11
)
IUSE="debug doc +eeze +nls pam static-libs systemd +udev ukit wayland
	${E_MODULES_DEFAULT[@]/#/+enlightenment_modules_}
	${E_MODULES[@]/#/enlightenment_modules_}
"
REQUIED_USE="!udev? ( eeze )"

RDEPEND="|| ( >=dev-libs/efl-1.18.0 >=media-libs/elementary-1.8.3[X,wayland?] )
	debug? ( dev-util/valgrind )
	udev? ( virtual/udev )
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
	enlightenment_modules_mixer? ( >=media-libs/alsa-lib-1.0.8 )
	nls? ( virtual/libintl )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd )
	wayland? (
		>=dev-libs/wayland-1.3.0
		>=x11-libs/pixman-0.31.1
		>=x11-libs/libxkbcommon-0.3.1
	)"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog README )

AUTOTOOLS_IN_SOURCE_BUILD=1
S="${WORKDIR}/${P/_/-}"

src_configure()
{
	local -a myconfargs=(
		${EXTRA_E_CONF}
		--disable-device-hal
		--disable-simple-x11
		--disable-wayland-only
		--enable-conf
		--enable-device-udev # instead of hal
		--enable-enotify
		--enable-files
		--enable-install-enlightenment-menu
		--enable-install-sysactions
		$(use_enable doc)
		$(use_enable nls)
		$(use_enable pam)
		$(use_enable static-libs static)
		$(use_enable systemd)
		$(use_enable ukit mount-udisks)
		$(use_enable eeze mount-eeze)
		$(use_enable wayland wayland-clients)
		$(usex wayland '--enable-wl-desktop-shell' '')
	)
	local i
	for i in ${E_MODULES_DEFAULT} ${E_MODULES}; do
		myeconfargs+=( $(use_enable enlightenment_modules_${i} ${i}) )
	done
	autotools-utils_src_configure
}
