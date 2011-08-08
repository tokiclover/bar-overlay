# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git-2 

EAPI=4

DESCRIPTION=""
HOMEPAGE="http://linux-hybrid-graphics.blogspot.com/"
EGIT_REPO_URI="https://github.com/mkottman/acpi_call"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="git"

DEPEND="dev-vcs/git"
RDEPEND="${DEPEND}"

src_compile(){
	cd "${WORKDIR}"/*
	make || die "failed to compile."
}

src_install() {
	install -m 644 "${WORKDIR}"/*/acpi_call.ko /lib/modules/`uname -r`/misc \
	|| die "Failed to install acpi_call.ko module."
	depmod -e -F /usr/src/linux-`uname -r`/System.map -v `uname -r`
}

