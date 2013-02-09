# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/sys-power/acpi_call/acpi_call-9999.ebuild,v 1.1 2011/11/05 -tclover Exp $

EAPI=2

inherit linux-mod git-2 

DESCRIPTION="A module for Linux Hybrid Switchable graphics based on ACPI call as its name imply."
HOMEPAGE="http://linux-hybrid-graphics.blogspot.com/"
EGIT_REPO_URI="git://github.com/mkottman/acpi_call.git"
EGIT_PROJECT=${PN}

LICENSE="GPL-3"
SLOT="0"
IUSE="examples nvidia-hybrid-windump"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${PN}

MODULE_NAMES="acpi_call(misc:${S})"

src_prepare() { sed -i -e "s:default:module:" Makefile || die "eek!"; }

src_install() {
	linux-mod_src_install
	insinto /usr/share/acpi_call/
	doins test_off.sh || die "eek!"
	doins README || die "eek!"
	use examples doins {asus1215n,m11xr2}.sh || die "eek!"
	einfo "More info and scripts from http://linux-hybrid-graphics.blogspot.com"
}
