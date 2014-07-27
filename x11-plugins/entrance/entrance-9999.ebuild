# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-plugins/entrance/entrance-9999.ebuild,v 1.2 2014/07/26 12:02:10 -tclover Exp $

EAPI=5

EGIT_SUB_PROJECT="enlightenment/misc"
EGIT_URI_APPEND=""

inherit enlightenment

DESCRIPTION="PAM compatible session manager, epigone of entrance"

IUSE="consolekit ekbd grub2 +pam static-libs systemd"

DEPEND=">=sys-devel/gettext-0.12.1
	>=dev-libs/efl-1.8.0
	>=x11-wm/enlightenment-0.17.0
	>=x11-libs/elementary-1.8.0"
RDEPEND="pam? ( virtual/pam )
	consolekit? ( sys-auth/consolekit )
	grub2? ( sys-boot/grub:2 )
	ekbd? ( x11-plugins/ekbd )"

src_configure() {
	E_ECONF=(
		$(use_enable consolekit)
		$(use_enable ekbd)
		$(use_enable grub2)
		$(use_enable pam)
		$(use_enable systemd)
	)
	enlightenment_src_configure
}

pkg_postinst(){
	use grub2 && einfo "do not forget to add this line 'GRUB_DEFAULT=saved' to '/etc/default/grub'"
}
