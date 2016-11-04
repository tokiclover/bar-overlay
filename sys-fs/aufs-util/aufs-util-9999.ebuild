# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-fs/aufs-utils/aufs-utils-9999.ebuild v1.9 2015/05/05 23:23:47 Exp $

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

version_setup()
{
	local arg num=1
	for arg; do
		if (( $((${num})) == ${#} )); then
			branch=${arg}
			break
		elif (( ${arg} >= ${KV_MINOR} )); then
			branch=\$$((${num}-1))
			break
		elif (( ${arg} == ${KV_MINOR} )); then
			branch=${arg}
			break
		fi
		num=$((${num}+1))
	done
}

pkg_setup()
{
	# this is needed so merging a binpkg aufs-util is possible
	# w/out a kernel unpacked on the system
	[[ -n "$PKG_SETUP_HAS_BEEN_RAN" ]] && return

	get_version

	local branch
	case "${KV_MAJOR}" in
		(3) version_setup 0 2 9 14;;
		(4) version_setup 0 1;;
		(*) die "Unsupported kernel!";;
	esac
:	${branch:=x-rcN}
	branch="${KV_MAJOR}.${branch}"
	export EGIT_BRANCH="aufs${branch}"
	
	CONFIG_CHECK="$(usex fhsm 'AUFS_FHSM' '!AUFS_FHSM')"
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
	use fhsm && BuildFHSM=yes || BuildFHSM=no
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" KDIR="${KV_DIR}" \
		BuildFHSM=${BuildFHSM}
}

src_install()
{
	emake DESTDIR="${D}" install BuildFHSM=${BuildFHSM}
	unset BuildFHSM
	dodoc README
}
