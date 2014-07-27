# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: x11-plugins/ekbd/ekbd-9999.ebuild,v 1.2 2014/07/26 12:02:10 -tclover Exp $

EAPI=5

EGIT_SUB_PROJECT="enlightenment/libs"
EGIT_URI_APPEND=""

inherit enlightenment

DESCRIPTION="A smart vkbd(virtual keyboard) library inspired by illume-keyboard."
IUSE=""

DEPEND=">=sys-devel/gettext-0.12.1
	>=dev-libs/efl-1.8.0[X]
	>=x11-libs/elementary-1.8.0[X]"
RDEPEND="${DEPEND}"

