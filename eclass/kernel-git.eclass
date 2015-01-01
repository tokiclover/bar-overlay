# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: eclass/kernel-git.eclass,v 1.0 2014/12/31 20:33:34 -tclover Exp $

# @ECLASS: kernel-git.eclass
# @MAINTAINER: tclover@bar-overlay
# @DESCRIPTION: portage eclass base functions used by 
# sys-kernel/git-sources::bar ebuilds

inherit kernel-2 git-2

EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
EGIT_COMMIT=v${PV/%.0}
EGIT_NOUNPACK="yes"

RDEDEPEND="hardened? ( sys-apps/paxctl sys-apps/gradm )"
DEPEND="${RDEPEND}"

case "${EAPI:-5}" in
	4|5) EXPORT_FUNCTIONS src_unpack src_prepare;;
	*) die "EAPI=\"${EAPI}\" is not supported";;
esac

# @ECLASS-VARIABLE: MKV
# @DESCRIPT: *major* kernel version release
:	${MKV:=${KV_MAJOR}.${KV_MINOR}}

# @ECLASS-VARIABLE: AUFS_VER
# @DESCRIPTION: AUFS version to use
:	${AUFS_VER:=${MKV}}
# @ECLASS-VARIABLE: EGIT_REPO_AUFS
# @DESCRIPTION: AUFS git URI
:	${EGIT_REPO_AUFS:="git://git.code.sf.net/p/aufs/aufs${KV_MAJOR}-standalone.git"}
# @ECLASS-VARIABLE: AUFS_EXTRA_PATCH
# @DESCRIPTION: extra patches included in AUFS package to use

# @ECLASS-VARIABLE: BFS_VER
# @DESCRIPTION: BFS version string
# @ECLASS-VARIABLE: BFS_SRC
# @DESCRIPTION: BFS src file
:	${BFS_SRC:=${MKV}-sched-bfs-${BFS_VER}.patch}
# @ECLASS-VARIABLE: BFS_BASE_PATCH
# @DESCRIPTION: bfs base patch to patch the unpacked files

# @ECLASS-VARIABLE: BFS_EXTRA_PATCH
# @DESCRIPTION: bfs extra patch included in ck broken-out archive

## @ECLASS-VARIABLE: BLD_VER
## @DESCRIPTION: bld version string
#:	${BLD_VER:=${MKV}.0}
## @ECLASS-VARIABLE: BLD_URI
## @DESCRIPTION: bld src URI
#:	${BLD_URI:="https://bld.googlecode.com"}
## @ECLASS-VARIABLE: BLD_SRC
## @DESCRIPTION: BLD src file
#:	${BLD_SRC:=bld-${MKV}.0.patch}

# @ECLASS-VARIABLE: CK_VER
# @DESCRIPTION: -ck patchset version string
# @ECLASS-VARIABLE: CK_URI
# @DESCRIPTION: -ck patchset src URI
:	${CK_URI:="http://ck.kolivas.org/patches/${KV_MAJOR}.0/${MKV}"}
# @ECLASS-VARIABLE: CK_SRC
# @DESCRIPTION: -ck src file
:	${CK_SRC:=${CK_VER}-broken-out.tar.bz2}

# @ECLASS-VARIABLE: GEN_VER
# @DESCRIPTION: gentoo base patchset version string
:	${GEN_VER:=${MKV}-1}
# @ECLASS-VARIABLE: GEN_URI
# @DESCRIPTION: gentoo patchset src URI
:	${GEN_URI:="http://dev.gentoo.org/~mpagano/genpatches/tarballs"}
# @ECLASS-VARIABLE: GEN_SRC
# @DESCRIPTION: gentoo base src file
:	${GEN_SRC:=genpatches-${GEN_VER}.base.tar.xz}

# @ECLASS-VARIABLE: FBC_VER
# @DESCRIPTION: fbcondecor version string: genpatches extras version
:	${FBC_VER:=${GEN_VER}}
# @ECLASS-VARIABLE: FBC_SRC
# @DESCRIPTION: gentoo extras src file
:	${FBC_SRC:=genpatches-${FBC_VER}.extras.tar.xz}

# @ECLASS-VARIABLE: BFQ_VER
# @DESCRIPTION: BFQ version string: genpatches experimental version
:	${BFQ_VER:=${GEN_VER}}
# @ECLASS-VARIABLE: BFQ_SRC
# @DESCRIPTION: gentoo experimental src file
:	${BFQ_SRC:=genpatches-${BFQ_VER}.experimental.tar.xz}

# @ECLASS-VARIABLE: GHP_VER
# @DESCRIPTION: gentoo hardened uni patch version string
:	${GHP_VER:=${MKV}.${KV_PATCH}-1}
# @ECLASS-VARIABLE: GHP_URI
# @DESCRIPTION: gentoo hardened uni patch src URI
:	${GHP_URI:="http://dev.gentoo.org/~blueness/hardened-sources/hardened-patches"}
# @ECLASS-VARIABLE: GHP_SRC
# @DESCRIPTION: gentoo hardened uni patch src file
:	${GHP_SRC:=hardened-patches-${GHP_VER}.extras.tar.bz2}

# @ECLASS-VARIABLE: OPT_VER
# @DESCRIPTION: cpu optimization kind of *version* string
:	${OPT_VER:="outdated_versions/linux-3.2+/gcc-4.2+"}
# @ECLASS-VARIABLE: OPT_URI
# @DESCRIPTION: cpu optimization src URI
:	${OPT_URI:="https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master"}
# @ECLASS-VARIABLE: OPT_FILE
# @DESCRIPTION: cpu optimization original src file name
:	${OPT_FILE:="enable_additional_cpu_optimizations_for_gcc.patch"}
# @ECLASS-VARIABLE: OPT_SRC
# @DESCRIPTION: cpu optimization src file
:	${OPT_SRC:=${OPT_VER#*/}}
OPT_SRC="${OPT_SRC/\//-}.patch"

# @ECLASS-VARIABLE: RS4_VER
# @DESCRIPTION: reiser4 version string
:	${RS4_VER:=${OKV}}
# @ECLASS-VARIABLE: RS4_URI
# @DESCRIPTION: reiser4 src URI
:	${RS4_URI:="mirror://sourceforge/project/reiser4/reiser4-for-linux-3.x"}
# @ECLASS-VARIABLE: RS4_SRC
# @DESCRIPTION: reiser4 src file
:	${RS4_SRC:=reiser4-for-${RS4_VER}.patch.gz}

# @ECLASS-VARIABLE: RT_URI
# @DESCRIPTION: -rt version string
:	${RT_VER:=${OKV}-rt1}
# @ECLASS-VARIABLE: RT_URI
# @DESCRIPTION: -rt src URI
:	${RT_URI:="https://www.kernel.org/pub/linux/kernel/projects/rt/${MKV}"}
# @ECLASS-VARIABLE: RT_SRC
# @DESCRIPTION: -rt src file
:	${RT_SRC:=patch-${RT_VER}.patch.xz}

# @ECLASS-VARIABLE: TOI_VER
# @DESCRIPTION: tuxonice version string
# @ECLASS-VARIABLE: TOI_URI
# @DESCRIPTION: tuxonice URI
:	${TOI_URI:="http://tuxonice.nigelcunningham.com.au/downloads/all"}
# @ECLASS-VARIABLE: TOI_SRC
# @DESCRIPTION: tuxonice src file
:	${TOI_SRC:=tuxonice-for-linux-${TOI_VER}.patch.bz2}

# @ECLASS-VARIABLE: UKSM_EXV
# @DESCRIPTION: uksm version string
:	${UKSM_EXV:=0.1.2.3}
# @ECLASS-VARIABLE: UKSM_URI
# @DESCRIPTION: uksm src URI
:	${UKSM_URI:="http://kerneldedup.org/download/uksm/${UKSM_EXV}"}
# @ECLASS-VARIABLE: UKSM_VER
# @DESCRIPTION: uksm base version string
# @ECLASS-VARIABLE: UKSM_SRC
# @DESCRIPTION: uksm src file
:	${UKSM_SRC:=uksm-${UKSM_EXV}-for-v${UKSM_VER}.patch}

# @FUNCTION: src_patch_unpack
src_patch_unpack() {
	[[ $# < 1 ]] && return $?
	local dir="${WORKDIR}"/${2} n=/dev/null
	mkdir -p "${dir}"
	pushd "${dir}" >${n}
	unpack ${1}
	popd >${n}
}

# @FUNCTION: linux-git_src_unpack
kernel-git_src_unpack() {
	debug-print-function ${FUNCNAME} "${@}"

	git-2_src_unpack
	if use_if_iuse aufs; then
		EGIT_BRANCH=aufs${AUFS_VER}
		unset EGIT_COMMIT
		export EGIT_NONBARE=yes
		export EGIT_REPO_URI=${EGIT_REPO_AUFS}
		export EGIT_SOURCEDIR="${WORKDIR}"/aufs${KV_MAJOR}-standalone
		export EGIT_PROJECT=aufs${KV_MAJOR}-standalone.git
		git-2_src_unpack
	fi
	if use_if_iuse bfs || use_if_iuse ck; then
		unpack ${CK_SRC}
	fi
	use_if_iuse hardened && unpack ${GHP_SRC}
	use_if_iuse gentoo     && src_patch_unpack ${GEN_SRC} base
	use_if_iuse fbcondecor && src_patch_unpack ${FBC_SRC} extras
	use_if_iuse bfq        && src_patch_unpack ${BFQ_SRC} experimental
}

# @FUNCTION: kernel-git_src_prepare
kernel-git_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	epatch_user

	if use_if_iuse aufs; then
		local dir src=aufs${KV_MAJOR}-standalone
		local -a PATCHES=(
			"${WORKDIR}"/${src}/aufs${KV_MAJOR}-{kbuild,base,mmap}.patch
			"${WORKDIR}"/${src}/aufs${KV_MAJOR}-{standalone,loopback}.patch
		)

		for dir in Documentation fs; do
			cp -a "${WORKDIR}"/${src}/${dir} "${S}" || die
		done

		cp -a {"${WORKDIR}/${src}","${S}"}/include/uapi/linux/aufs_type.h || die
		epatch "${PATCHES[@]}"
		[[ -n "${AUFS_EXTRA_PATCH}" ]] &&
			epatch "${WORKDIR}"/${src}/${AUFS_EXTRA_PATCH}
	fi

	use_if_iuse hardened   && epatch "${WORKDIR}"/${GHP_VER/%-*}/*.patch
	use_if_iuse gentoo     && epatch "${WORKDIR}"/base/*.patch
	use_if_iuse fbcondecor && epatch "${WORKDIR}"/extras/*.patch
	use_if_iuse bfq        && epatch "${WORKDIR}"/experimental/*.patch

	if use_if_iuse ck || use_if_iuse bfs; then
		[[ -n "${BFS_BASE_PATCH}" ]] &&
			epatch "${WORKDIR}"/patches/${BFS_BASE_PATCH}
	fi
	if use_if_iuse ck; then
		sed -e "/ck.*-version.patch/d" \
			-i "${WORKDIR}"/patches/series || die
		while read line; do
			epatch "${WORKDIR}"/patches/$line
		done <"${WORKDIR}"/patches/series
 	elif use_if_iuse bfs; then
		epatch "${WORKDIR}"/patches/${BFS_SRC}
		epatch "${WORKDIR}"/patches/hz-{default_1000,no_default_250}.patch
		[[ -n "${BFS_EXTRA_PATCH}" ]] &&
			epatch "${WORKDIR}"/patches/${BFS_EXTRA_PATCH}
	fi
	
	use_if_iuse reiser4 && epatch "${DISTDIR}"/${RS4_SRC}
	use_if_iuse rt && epatch "${DISTDIR}"/${RT_SRC}
	use_if_iuse toi && epatch "${DISTDIR}"/${TOI_SRC}
	use_if_iuse uksm && epatch "${DISTDIR}"/${UKSM_SRC}
	use_if_iuse optimization && ! use_if_iuse bfq &&
		epatch "${DISTDIR}"/${OPT_SRC}
	
	rm -fr .git*
	sed -e "s,EXTRAVERSION =.*$,EXTRAVERSION = -git," -i Makefile || die
}
