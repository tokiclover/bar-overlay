# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-fs/aufs-utils/aufs-utils-9999.ebuild v1.8 2015/03/09 23:23:47 -tclover Exp $

EAPI=5

inherit multilib toolchain-funcs git-2 linux-info

DESCRIPTION="AUFS filesystem utilities"
HOMEPAGE="http://aufs.sourceforge.net/"
EGIT_REPO_URI="git://git.code.sf.net/p/aufs/aufs-util.git"

LICENSE="GPL-2"
IUSE="fhsm kernel-builtin"
SLOT="0/${PV}"

RDEPEND="${DEPEND} !sys-fs/aufs3 !sys-fs/aufs2"
DEPEND="!kernel-builtin? ( =sys-fs/${P/util/standalone}:=[fhsm?] )"

KV_SUPPORT=(
	3.20
	3.{0,2,9,14}
)

pkg_setup()
{
	# this is needed so merging a binpkg aufs-util is possible
	# w/out a kernel unpacked on the system
	[[ -n "$PKG_SETUP_HAS_BEEN_RAN" ]] && return

	get_version

	local branch
	for (( i=1; i<${#KV_SUPPORT[@]}; i++ )); do
		if [[ $((${i}+1)) -eq ${#KV_SUPPORT[@]} ]]; then
			branch=${KV_SUPPORT[i]}
			break
		elif [[ ${KV_SUPPORT[i]#*.} -gt ${KV_MINOR} ]]; then
			branch=${KV_SUPPORT[$((${i}-1))]}
			break
		elif [[ ${KV_SUPPORT[i]#*.} -eq ${KV_MINOR} ]]; then
			branch=${KV_SUPPORT[i]}
			break
		elif [[ ${KV_MAJOR} -ge ${KV_SUPPORT[0]#*.} ]]; then
			branch=${KV_MAJOR}.x-rcN
			break
		fi
	done
	export EGIT_BRANCH="aufs${branch}"
	
	CONFIG_CHECK="$(usex fhsm 'AUFS_FHSM' '')"
	if use kernel-builtin; then
		CONFIG_CHECK="AUFS_FS ${CONFIG_CHECK}"
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
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" KDIR="${KV_DIR}" \
		$(usex fhsm 'BuildFHSM=yes' 'BuildFHSM=no')
}

src_install()
{
	emake DESTDIR="${D}" install \
		$(usex fhsm 'BuildFHSM=yes' 'BuildFHSM=no')

	docinto /usr/share/doc/${PF}
	dodoc README
}
