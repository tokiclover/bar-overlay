# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-plugins/entrance/entrance-9999.ebuild,v 1.4 2014/12/22 12:02:10 -tclover Exp $

EAPI=5

inherit autotools-utils git-2

DESCRIPTION="PAM compatible display manager build on EFL"
HOMEPAGE="https://enlightenment.org"
EGIT_REPO_URI="git://git.enlightenment.org/misc/${PN}.git"

IUSE="consolekit vkbd grub +pam systemd"
LICENSE="BSD-2"
KEYWORDS=""
SLOT="0"

RDEPEND="${DEPEND}
	app-admin/sudo
	>=dev-libs/efl-1.8.0[systemd?]
	>=x11-wm/enlightenment-0.17.0[systemd?]
	>=media-libs/elementary-1.8.0
	pam? ( virtual/pam )
	consolekit? ( sys-auth/consolekit )
	grub? ( sys-boot/grub:2 )
	vkbd? ( x11-plugins/ekbd )"
DEPEND="${RDEPEND}
	virtual/libintl"

AUTOTOOLS_AUTORECONF=1

src_configure()
{
	local -a myeconfargs=(
		$(use_enable consolekit)
		$(use_enable vkbd ekbd)
		$(use_enable grub grub2)
		$(use_enable pam)
		$(use_enable systemd)
	)
	autotools-utils_src_configure
}

pkg_postinst()
{
	if use grub; then
		elog
		elog "do not forget to add this line line to \`/etc/default/grub':"
		elog "'GRUB_DEFAULT=saved'"
	fi
}
