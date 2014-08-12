# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-fs/aufs-utils/aufs-utils-9999.ebuild v1.4 2014/08/08 23:23:47 -tclover Exp $

EAPI=5

inherit multilib toolchain-funcs git-2 linux-info

DESCRIPTION="AUFS3 filesystem utilities."
HOMEPAGE="http://aufs.sourceforge.net/"
EGIT_REPO_URI="git://aufs.git.sourceforge.net/gitroot/aufs/aufs-util.git"

RDEPEND="${DEPEND} !sys-fs/aufs3 !sys-fs/aufs2"
DEPEND="!kernel-builtin? ( =sys-fs/${P/utils/standalone} )"

LICENSE="GPL-2"
SLOT="0"

IUSE="kernel-builtin"

AUFS_UTILS_VERSION=( 0 2 9 x-rcN )

pkg_setup() {
	get_version
	local i version=${KV_MINOR}

	for (( i=0; i<${#AUFS_UTILS_VERSION[@]}; i++ )); do
		if [[ ${AUFS_UTILS_VERSION[$(($i+1))]} -eq x-rcN ]]; then
			EGIT_BRANCH=aufs${KV_MAJOR}.${AUFS_UTILS_VERSION[$i]}
			break
		elif [[ ${AUFS_UTILS_VERSION[$i]} -gt ${version} ]]; then
			EGIT_BRANCH=aufs${KV_MAJOR}.${AUFS_UTILS_VERSION[$(($i-1))]}
			break
		elif [[ ${AUFS_UTILS_VERSION[$i]} -eq ${version} ]]; then
			EGIT_BRANCH=aufs${KV_MAJOR}.${AUFS_UTILS_VERSION[$i]}
			break
		fi
	done
	
	if use kernel-builtin; then
		CONFIG_CHECK="AUFS_FS"
		ERROR_AUSFS_FS="aufs have to be enabled [y|m]."
		linux-info_pkg_setup
		if [ -d "${KV_DIR}"/usr/include ]; then
			ln -s "${KV_DIR}"/usr/include "${T}"/include || die
		else
			die "you have to \`cd ${KV_DIR}; make headers_install\' before merging"
		fi
	else
		ln -s /usr/include "${T}"/include || die
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/makefile.patch
	mv "${T}"/include . || die
}

src_compile() {
	emake CC=$(tc-getCC) AR=$(tc-getAR) KDIR=${KV_DIR}
}

src_install() {
	emake DESTDIR="${D}" install
	docinto /usr/share/doc/${PF}
	newdoc README README-utils
}
