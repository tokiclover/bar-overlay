# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-power/acpi_call/acpi_call-9999.ebuild,v 1.2 2014/07/15 -tclover Exp $

EAPI=5

inherit eutils linux-mod linux-info git-2 

DESCRIPTION="A module for Linux Hybrid Switchable graphics based on ACPI call"
HOMEPAGE="http://github.com/mkottman/acpi_call"
EGIT_REPO_URI="git://github.com/mkottman/acpi_call.git"
EGIT_PROJECT=${PN}.git

LICENSE="GPL-2"
SLOT="0"
IUSE=""

CONFIG_CHECK="ACPI"
MODULE_NAMES="acpi_call(misc:${S})"
BUILD_TARGETS="default"

DOCS=( README.md )

src_compile(){
	BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}"
	linux-mod_src_compile
}
