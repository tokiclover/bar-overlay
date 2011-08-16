# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/aufs2/aufs2-0_p20110327.ebuild,v 1.1 2011/03/27 13:09:40 jlec Exp $

EAPI="4"

inherit multilib toolchain-funcs git-2 linux-info

DESCRIPTION="AUFS-2.1 filesystem utilities."
HOMEPAGE="http://aufs.sourceforge.net/"
EGIT_REPO_URI="git://aufs.git.sourceforge.net/gitroot/aufs/aufs-util.git"

RDEPEND="${DEPEND}
		!sys-fs/aufs2"
DEPEND="!kernel? ( =sys-fs/${P/util/standalone}[header] )"

get_version
if kernel_is gt 3 0; then
	kernel_is gt 3 0 2 && EGIT_BRANCH=aufs${KV_MAJOR}.x-rcN || EGIT_BRANCH=aufs${KV_MAJOR}.${KV_MINOR}
else
	EGIT_REPO_URI=${EGIT_REPO_URI/-/${KV_MAJOR}-}
	EGIT_PROJECT=${PN/-/${KV_MAJOR}-}
	EGIT_BRANCH=aufs${KV_MAJOR}.2
	RDEPEND="${RDEPEND} !sys-fs/${PN/-/${KV_MAJOR}-}"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="kernel"

pkg_setup(){
	if use kernel; then
		CONFIG_CHECK="AUFS_FS"
		ERROR_AUSFS_FS="aufs have to be enabled [y|m]."
		linux-info_pkg_setup
		ln -sf "${KV_DIR}"/include/ include
	else
		ln -sf /usr/include/ include
	fi
}

src_prepare() {
	sed -i "/LDFLAGS += -static -s/d" Makefile || die "eek!"
	sed -i -e "s:m 644 -s:m 644:g" -e "s:/usr/lib:/usr/$(get_libdir):g"	libau/Makefile || die "eek!"
	mv ../../include . || die "eek!"
}

src_compile() {
	emake CC=$(tc-getCC) AR=$(tc-getAR) KDIR=${KV_DIR} C_INCLUDE_PATH=./include
}

src_install() {
	emake DESTDIR="${D}" install
	docinto
	newdoc README README-utils
}
