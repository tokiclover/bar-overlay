# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1 git-r3 linux-mod

DESCRIPTION="Razer Drivers for Linux"
HOMEPAGE="https://openrazer.github.io/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	media-libs/libsdl2
	media-libs/sdl2-image
	sci-libs/fftw:3.0
	dev-python/daemonize[$PYTHON_USEDEP]
	dev-python/dbus-python[$PYTHON_USEDEP]
	dev-python/notify2[$PYTHON_USEDEP]
	dev-python/numpy[$PYTHON_USEDEP]
	dev-python/pygobject[$PYTHON_USEDEP]
	dev-python/python-evdev[$PYTHON_USEDEP]
	dev-python/pyudev[$PYTHON_USEDEP]
	dev-python/setproctitle[$PYTHON_USEDEP]
	x11-misc/xautomation
	x11-misc/xdotool

	"
DEPEND="${RDEPEND}
	app-misc/jq
"

# This is a bit weird, but it's end result is what we want.
BUILD_TARGETS="clean modules"
BUILD_PARAMS="-j1 -C /usr/src/linux SUBDIRS=${S}/driver"
MODULE_NAMES="
	razerkbd(hid:${S}/driver)
	razermouse(hid:${S}/driver)
	razerfirefly(hid:${S}/driver)
	razerkraken(hid:${S}/driver)
	razermug(hid:${S}/driver)
	razercore(hid:${S}/driver)
"

src_install() {
	linux-mod_src_install
	emake DESTDIR="${D}" \
		ubuntu_udev_install \
		daemon_install \
		python_library_install
}
