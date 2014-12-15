# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-fs/aufs-utils/aufs-utils-9999.ebuild v1.5 2014/12/01 23:23:47 -tclover Exp $

EAPI=5

inherit multilib toolchain-funcs git-2 linux-info

DESCRIPTION="AUFS filesystem utilities"
HOMEPAGE="http://aufs.sourceforge.net/"
EGIT_REPO_URI="git://git.code.sf.net/p/aufs/aufs-util.git"

RDEPEND="${DEPEND} !sys-fs/aufs3 !sys-fs/aufs2"
DEPEND="!kernel-builtin? ( =sys-fs/${P/util/standalone}:= )"

LICENSE="GPL-2"
IUSE="kernel-builtin"
SLOT="0/${PV}"

AUFS_VERSION=( 17 0 2 9 x-rcN )

pkg_setup()
{
	# this is needed so merging a binpkg aufs-util is possible
	# w/out a kernel unpacked on the system
	[[ -n "$PKG_SETUP_HAS_BEEN_RAN" ]] && return

	get_version

	local version="${KV_MINOR}"
	for (( i=1; i<${#AUFS_VERSION[@]}; i++ )); do
		if [[ "${AUFS_VERSION[$(($i+1))]}" == "x-rcN" ]]; then
			version=${AUFS_VERSION[$i]}
			break
		elif [[ "${AUFS_VERSION[$i]}" -gt "${version}" ]]; then
			version=${AUFS_VERSION[$(($i-1))]}
			break
		elif [[ "${AUFS_VERSION[$i]}" -eq "${version}" ]]; then
			break
		elif [[ "${AUFS_VERSION[0]}" -eq "${version}" ]]; then
			version=x-rcN
			break
		fi
	done
	version="${KV_MAJOR}.${version}"
	export EGIT_BRANCH="aufs${version}"
	
	if use kernel-builtin; then
		CONFIG_CHECK="AUFS_FS"
		ERROR_AUSFS_FS="aufs have to be enabled [y|m]."
		linux-info_pkg_setup
		if [[ -d "${KV_DIR}"/usr/include ]]; then
			ln -s "${KV_DIR}"/usr/include "${T}"/include || die
		else
			die "you have to \`cd ${KV_DIR}; make headers_install\' before merging"
		fi
	else
		ln -s /usr/include "${T}"/include || die
	fi
	
	export PKG_SETUP_HAS_BEEN_RAN=1
}

src_prepare()
{
	epatch "${FILESDIR}"/makefile.patch
	mv "${T}"/include . || die
}

src_compile()
{
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" KDIR="${KV_DIR}"
}

src_install()
{
	emake DESTDIR="${D}" install
	docinto /usr/share/doc/${PF}
	dodoc README
}
