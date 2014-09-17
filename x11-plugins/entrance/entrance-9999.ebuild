# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-plugins/entrance/entrance-9999.ebuild,v 1.3 2014/09/16 12:02:10 -tclover Exp $

EAPI=5

inherit autotools-utils git-2

DESCRIPTION="a PAM compatible display manager based on EFL, epigone of entrance"
HOMEPAGE="https://enlightenment.org"
EGIT_REPO_URI="git://git.enlightenment.org/misc/${PN}.git"

IUSE="consolekit vkbd grub +pam systemd"
LICENSE="BSD-2"
KEYWORDS=""
SLOT="0"

DEPEND="virtual/libintl
	app-admin/sudo
	>=dev-libs/efl-1.8.0[systemd?]
	>=x11-wm/enlightenment-0.17.0[systemd?]
	>=media-libs/elementary-1.8.0"
RDEPEND="pam? ( virtual/pam )
	consolekit? ( sys-auth/consolekit )
	grub? ( sys-boot/grub:2 )
	vkbd? ( x11-plugins/ekbd )"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myeconfargs=(
		$(use_enable consolekit)
		$(use_enable vkbd ekbd)
		$(use_enable grub grub2)
		$(use_enable pam)
		$(use_enable systemd)
	)
	autotools-utils_src_configure
}

pkg_postinst(){
	if use grub; then
		elog "do not forget to add this line line to \`/etc/default/grub':"
		elog "'GRUB_DEFAULT=saved'"
	fi
}
