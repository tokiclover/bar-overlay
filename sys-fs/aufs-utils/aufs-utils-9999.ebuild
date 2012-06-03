# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-fs/aufs-util/aufs-util-9999.ebuild v1.3 2012/06/03 03:20:48 -tclover Exp $

EAPI="4"

inherit multilib toolchain-funcs git-2 linux-info

DESCRIPTION="AUFS2 filesystem utilities."
HOMEPAGE="http://aufs.sourceforge.net/"
EGIT_REPO_URI="git://aufs.git.sourceforge.net/gitroot/aufs/aufs-util.git"

RDEPEND="${DEPEND}
		!sys-fs/aufs3"
DEPEND="!kernel-builtin? ( =sys-fs/${P/utils/standalone}[header] )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="kernel-builtin"

pkg_setup() {
	get_version
	if use kernel-builtin; then
		CONFIG_CHECK="AUFS_FS"
		ERROR_AUSFS_FS="aufs have to be enabled [y|m]."
		linux-info_pkg_setup
		if [ -d "${KV_DIR}"/usr/include ]; then
			ln -sf "${KV_DIR}"/usr/include include
		else die "you have to \`cd ${KV_DIR}; make headers_install\' before merging"; fi
	else ln -sf /usr/include/ include; fi

	if [[ ${KV_MAJOR} -eq 3 ]]; then
		if [[ "${CKV}" != "${OKV}" ]]; then EGIT_BRANCH=aufs${KV_MAJOR}.x-rcN
		else EGIT_BRANCH=aufs${KV_MAJOR}.0; fi
	elif [[ ${KV_MAJOR} -eq 2 ]]; then
		EGIT_REPO_URI=${EGIT_REPO_URI/-/${KV_MAJOR}-}
		EGIT_PROJECT=${PN/-/${KV_MAJOR}-}
		if [[ ${KV_PATCH} -lt 35 ]]; then EGIT_BRANCH=aufs${KV_MAJOR}.1
		else EGIT_BRANCH=aufs${KV_MAJOR}.2; fi
	fi
}

src_prepare() {
	sed -e '/LDFLAGS += -static -s/d' \
		-i Makefile || die
	sed -e 's:m 644 -s:m 644:g' -e 's:/usr/lib:/usr/$(get_libdir):g' \
		-i libau/Makefile || die
	mv ../../include . || die
}

src_compile() {
	emake CC=$(tc-getCC) AR=$(tc-getAR) KDIR=${KV_DIR} CPPFLAGS+=" -I\"${S}\"/include"
}

src_install() {
	emake DESTDIR="${D}" install
	docinto
	newdoc README README-utils
}
