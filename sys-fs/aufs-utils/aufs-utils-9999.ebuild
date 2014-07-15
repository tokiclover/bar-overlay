# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-fs/aufs-utils/aufs-utils-9999.ebuild v1.4 2014/07/14 23:23:47 -tclover Exp $

EAPI=5

inherit multilib toolchain-funcs git-2 linux-info

DESCRIPTION="AUFS2 filesystem utilities."
HOMEPAGE="http://aufs.sourceforge.net/"
EGIT_REPO_URI="git://aufs.git.sourceforge.net/gitroot/aufs/aufs-util.git"

RDEPEND="${DEPEND} !sys-fs/aufs3 !sys-fs/aufs2"
DEPEND="!kernel-builtin? ( =sys-fs/${P/utils/standalone} )"

LICENSE="GPL-2"
SLOT="0"

IUSE="kernel-builtin"

pkg_setup() {
	get_version
	EGIT_BRANCH=aufs${KV_MAJOR}.0
	
	if use kernel-builtin; then
		CONFIG_CHECK="AUFS_FS"
		ERROR_AUSFS_FS="aufs have to be enabled [y|m]."
		linux-info_pkg_setup
		if [ -d "${KV_DIR}"/usr/include ]; then
			ln -sf "${KV_DIR}"/usr/include include
		else
			die "you have to \`cd ${KV_DIR}; make headers_install\' before merging"
		fi
	else
		ln -sf /usr/include/ include
	fi
}

src_prepare() {
	sed -e '/LDFLAGS += -static -s/d' -i Makefile || die
	sed -e 's:m 644 -s:m 644:g' -e 's:/usr/lib:/usr/$(get_libdir):g' \
		-i libau/Makefile || die
	sed 's/get_libdir/libdir/g' -i libau/Makefile || die
	mv ../../include . || die
}

src_compile() {
	emake CC=$(tc-getCC) AR=$(tc-getAR) KDIR=${KV_DIR} CPPFLAGS+=" -I\"${S}\"/include"
}

src_install() {
	emake DESTDIR="${D}" libdir=$(get_libdir) install
	docinto
	newdoc README README-utils
}
