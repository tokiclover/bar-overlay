# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: eclass/kernel-git.eclass,v 2.0 2016/05/14 20:33:34 -tclover Exp $

# @ECLASS: kernel-git.eclass
# @MAINTAINER:
# bar-overlay <bar@overlay.org>
# @AUTHOR:
# Original author: tokiclover <tokiclover@gmail.com>
# @BLURB: Provide means to get multiple kernel path sets
# @DESCRIPTION:
# Export eclass base functions used by 
# sys-kernel/git-sources::bar package

# @ECLASS-VARIABLE: PATCHSET
# @DESCRIPTION:
# Array holding a list of use/patchset list
# PATCHSET=(bfs ck gentoo hardened reiser4)
:	${PATCHSET:=}

if [[ -z "${_KERNEL_GIT_ECLASS}" ]]; then
_KERNEL_GIT_ECLASS=1

inherit kernel-2 git-2
detect_version
detect_arch

case "${EAPI:-5}" in
	(4|5) EXPORT_FUNCTIONS src_unpack src_prepare;;
	(*) die "EAPI=\"${EAPI}\" is not supported";;
esac

EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
EGIT_COMMIT=v${PV/%.0}
EGIT_NOUNPACK="yes"

DESCRIPTION="Latest stable branch Linux kernel"
HOMEPAGE="http://www.kernel.org"

IUSE="${PATCHSET[*]}"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"

if has ck "${PATCHSET[@]}"; then
	if (( ${KV_MAJOR} == 4 )) && (( ${KV_MINOR} >= 8 )); then
REQUIRED_USE="${REQUIRED_USE}
	ck? ( muqss )"
	else
REQUIRED_USE="${REQUIRED_USE}
	ck? ( bfs )"
	fi
fi

RDEDEPEND="hardened? ( sys-apps/paxctl sys-apps/gradm )"
DEPEND="${RDEPEND}"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its (unstable and)
experimental nature. If you have any issues, try disabling a few USE flags
that you may suspect being the source of your issues because this ebuild is
based on the latest stable tree."

# @ECLASS-VARIABLE: OKV
# @DESCRIPTION:
# MAJOR.MINOR.PATCH (full kernel version/package version)
:	${OKV:=${PV}}
# @ECLASS-VARIABLE: MKV
# @DESCRIPTION:
# MAJOR.MINOR (mini kernel version)
:	${MKV:=${PV%.*}}

:	${KV_MAJOR:=${MKV%.*}}
:	${KV_MINOR:=${MKV#*.}}
:	${KV_PATCH:=${PV##*.}}

# @ECLASS-VARIABLE: AUFS_VER
# @DESCRIPTION:
# AUFS version to use
:	${AUFS_VER:=${MKV}}
# @ECLASS-VARIABLE: EGIT_REPO_AUFS
# @DESCRIPTION:
# AUFS git URI
:	${EGIT_REPO_AUFS:=}
case "${KV_MAJOR}" in
	(3)
:	${EGIT_REPO_AUFS:="git://git.code.sf.net/p/aufs/aufs${KV_MAJOR}-standalone.git"}
	;;
	(4)
:	${EGIT_REPO_AUFS:="git://github.com/sfjro/aufs${KV_MAJOR}-standalone.git"}
	;;
esac

# @ECLASS-VARIABLE: BFS_VER
# @DESCRIPTION:
# BFS version string
:	${BFS_VER:=}
# @ECLASS-VARIABLE: CK_VER
# @DESCRIPTION:
# -ck patchset version string
:	${CK_VER:=${MKV}-ck1}
# @ECLASS-VARIABLE: CK_URI
# @DESCRIPTION:
# -ck patchset source URI
:	${CK_URI:="http://ck.kolivas.org/patches/${KV_MAJOR}.0/${MKV}/${CK_VER}"}
:	${BFS_URI:=${CK_URI}}
# @ECLASS-VARIABLE: CK_SRC
# @DESCRIPTION:
# -ck source file
:	${CK_SRC:=${CK_VER}-broken-out.tar.bz2}
# @ECLASS-VARIABLE: BFS_SRC
# @DESCRIPTION:
# BFS source file
:	${BFS_SRC:=${CK_SRC}}
# @ECLASS-VARIABLE: MUQSS_VER
# @DESCRIPTION:
# MuQSS version string
:	${MUQSS_VER:=}
# @ECLASS-VARIABLE: MUQSS_SRC
# @DESCRIPTION:
# BFS source file
:	${MUQSS_SRC:=${CK_SRC}}

# @ECLASS-VARIABLE: GENTOO_VER
# @DESCRIPTION:
# Gentoo base patchset version string
:	${GENTOO_VER:=${MKV}-1}
# @ECLASS-VARIABLE: GENTOO_URI
# @DESCRIPTION:
# Gentoo patchset source URI
:	${GENTOO_URI:="http://dev.gentoo.org/~mpagano/genpatches/tarballs"}
# @ECLASS-VARIABLE: GENTOO_SRC
# @DESCRIPTION:
# Gentoo base source file
:	${GENTOO_SRC:=genpatches-${GENTOO_VER}.base.tar.xz}

# @ECLASS-VARIABLE: FBCONDECOR_VER
# @DESCRIPTION:
# Fbcondecor version string: genpatches extras version
:	${FBCONDECOR_VER:=${GENTOO_VER}}
# @ECLASS-VARIABLE: FBCONDECOR_SRC
# @DESCRIPTION:
# Gentoo extras source file
:	${FBCONDECOR_SRC:=genpatches-${FBCONDECOR_VER}.extras.tar.xz}
:	${FBCONDECOR_URI:=${GENTOO_URI}}

if (( ${KV_MAJOR} == 4 )) && (( ${KV_MINOR} >= 8 )); then
:	${BFQ_SRC:=${CK_SRC}}
:	${BFQ_URI:=${CK_URI}}
else
# @ECLASS-VARIABLE: BFQ_VER
# @DESCRIPTION:
# BFQ version string: genpatches experimental version
:	${BFQ_VER:=${GENTOO_VER}}
# @ECLASS-VARIABLE: BFQ_SRC
# @DESCRIPTION:
# Gentoo experimental source file
:	${BFQ_SRC:=genpatches-${BFQ_VER}.experimental.tar.xz}
:	${BFQ_URI:=${GENTOO_URI}}

# @ECLASS-VARIABLE: OPTIMIZATION_VER
# @DESCRIPTION:
# CPU optimization kind of *version* string
:	${OPTIMIZATION_VER:=${BFQ_VER}}
# @ECLASS-VARIABLE: OPTIMIZATION_URI
# @DESCRIPTION:
# CPU optimization source URI
:	${OPTIMIZATION_URI:=${BFQ_URI}}
# @ECLASS-VARIABLE: OPTIMIZATION_SRC
# @DESCRIPTION:
# CPU optimization source file
:	${OPTIMIZATION_SRC:=${BFQ_SRC}}
fi

# @ECLASS-VARIABLE: HARDENED_VER
# @DESCRIPTION:
# Gentoo hardened unified patch version string
:	${HARDENED_VER:=${OKV}-1}
# @ECLASS-VARIABLE: HARDENED_URI
# @DESCRIPTION:
# gentoo hardened unified patch source URI
:	${HARDENED_URI:="http://dev.gentoo.org/~blueness/hardened-sources/hardened-patches"}
# @ECLASS-VARIABLE: HARDENED_SRC
# @DESCRIPTION:
# Gentoo hardened unified patch source file
:	${HARDENED_SRC:=hardened-patches-${HARDENED_VER}.extras.tar.bz2}

# @ECLASS-VARIABLE: REISER4_VER
# @DESCRIPTION:
# Reiser4 version string
:	${REISER4_VER:=${OKV}}
# @ECLASS-VARIABLE: REISER4_URI
# @DESCRIPTION:
# Reiser4 source URI
:	${REISER4_URI:="mirror://sourceforge/project/reiser4/reiser4-for-linux-${KV_MAJOR}.x"}
# @ECLASS-VARIABLE: REISER4_SRC
# @DESCRIPTION:
# Reiser4 source file
:	${REISER4_SRC:=reiser4-for-${REISER4_VER}.patch.gz}

# @ECLASS-VARIABLE: RT_VER
# @DESCRIPTION:
# -rt version string
:	${RT_VER:=${OKV}-rt1}
# @ECLASS-VARIABLE: RT_URI
# @DESCRIPTION:
# -rt source URI
:	${RT_URI:="https://www.kernel.org/pub/linux/kernel/projects/rt/${MKV}/older"}
# @ECLASS-VARIABLE: RT_SRC
# @DESCRIPTION:
# -rt source file
:	${RT_SRC:=patch-${RT_VER}.patch.xz}

# @ECLASS-VARIABLE: TOI_VER
# @DESCRIPTION:
# tuxonice version string
:	${TOI_VER:=}
# @ECLASS-VARIABLE: TOI_URI
# @DESCRIPTION:
# tuxonice URI
:	${TOI_URI:="http://tuxonice.nigelcunningham.com.au/downloads/all"}
# @ECLASS-VARIABLE: TOI_SRC
# @DESCRIPTION:
# tuxonice source file
:	${TOI_SRC:=tuxonice-for-linux-${TOI_VER}.patch.bz2}

# @ECLASS-VARIABLE: UKSM_REV
# @DESCRIPTION:
# uksm version string
:	${UKSM_REV:=0.1.2.3}
# @ECLASS-VARIABLE: UKSM_URI
# @DESCRIPTION:
# uksm source URI
:	${UKSM_URI:="http://kerneldedup.org/download/uksm/${UKSM_REV}"}
# @ECLASS-VARIABLE: UKSM_VER
# @DESCRIPTION:
# uksm base version string
# @ECLASS-VARIABLE: UKSM_SRC
# @DESCRIPTION:
# uksm source file
:	${UKSM_SRC:=uksm-${UKSM_REV}-for-v${UKSM_VER}.patch}

SRC_URI+="
	${KERNEL_BASE_URI}/linux-${MKV}.tar.xz"
(( ${KV_PATCH} != 0 )) &&
SRC_URI+="
	${KERNEL_BASE_URI}/patch-${OKV}.xz"

SRC_URI+="$(eval
for u in "${PATCHSET[@]}"; do
	case "${u}" in
		(aufs) continue;;
	esac
	eval printf '"\n\t%s"' "\"${u}? ( \${${u^^[a-z]}_URI}/\${${u^^[a-z]}_SRC} )\""
done
)"
unset u {CK,BF{S,Q},FBCONDECOR,HARDENED,OPTIMIZATION,REISER4,RT,UKSM}_{URI,VER}

S="${WORKDIR}/linux-${OKV}-git"

# @FUNCTION: src_patch_unpack
# @DESCRIPTION:
# Internal wrapper to unpack patchset
src_patch_unpack()
{
	(( ${#} < 1 )) && return "${?}"
	local dir="${WORKDIR}"/${2} n=/dev/null
	mkdir -p "${dir}"
	pushd "${dir}" >${n}
	unpack ${1}
	popd >${n}
}

# @FUNCTION: linux-git_src_unpack
# @DESCRIPTION:
# Default exported function for unpack phase
kernel-git_src_unpack()
{
	debug-print-function ${FUNCNAME} "${@}"

	unpack ${A}
	mv linux-${MKV} linux-${OKV}-git || die

	if use_if_iuse aufs; then
		EGIT_BRANCH=aufs${AUFS_VER}
		unset EGIT_COMMIT
		export EGIT_NONBARE=yes
		export EGIT_REPO_URI=${EGIT_REPO_AUFS}
		export EGIT_SOURCEDIR="${WORKDIR}"/aufs${KV_MAJOR}-standalone
		export EGIT_PROJECT=aufs${KV_MAJOR}-standalone.git
		git-2_src_unpack
	fi
	if use_if_iuse bfs || use_if_iuse ck || use_if_iuse muqss; then
		unpack ${CK_SRC}
	fi
	use_if_iuse hardened   && unpack ${HARDENED_SRC}
	use_if_iuse gentoo     && src_patch_unpack ${GENTOO_SRC} base
	use_if_iuse fbcondecor && src_patch_unpack ${FBCONDECOR_SRC} extras
	if (( ${KV_MAJOR} == 4 )) && (( ${KV_MINOR} >= 8 )); then
		:;
	else
	use_if_iuse bfq        && src_patch_unpack ${BFQ_SRC} experimental
	fi
}

# @FUNCTION: kernel-git_src_prepare
# @DESCRIPTION:
# Default exported function for prepare phase
kernel-git_src_prepare()
{
	debug-print-function ${FUNCNAME} "${@}"

	PATCHES+=( "${WORKDIR}"/patch-${OKV} )
	epatch_user

	if use_if_iuse aufs; then
		local dir src=aufs${KV_MAJOR}-standalone
		PATCHES+=(
			"${WORKDIR}"/${src}/aufs${KV_MAJOR}-{kbuild,base,mmap}.patch
			"${WORKDIR}"/${src}/aufs${KV_MAJOR}-{standalone,loopback}.patch
		)
		for dir in Documentation fs; do
			cp -a "${WORKDIR}"/${src}/${dir} "${S}" || die
		done
		cp -a {"${WORKDIR}/${src}","${S}"}/include/uapi/linux/aufs_type.h || die
	fi

	use_if_iuse hardened   && PATCHES+=( "${WORKDIR}"/${MKV}*/*.patch )
	use_if_iuse gentoo     && PATCHES+=( "${WORKDIR}"/base/*.patch )
	use_if_iuse fbcondecor && PATCHES+=( "${WORKDIR}"/extras/*.patch )
	if (( ${KV_MAJOR} == 4 )) && (( ${KV_MINOR} >= 8 )); then
		if use_if_iuse bfq; then
			use_if_iuse ck || PATCHES+=( "${WORKDIR}"/patches/*BFQ*.patch )
		else
			rm -f "${WORKDIR}"/patches/series/*BFQ*.patch
		fi
	else
		use_if_iuse bfq    && PATCHES+=( "${WORKDIR}"/experimental/*BFQ*.patch )
	fi

	if use_if_iuse ck; then
		rm -f "${WORKDIR}"/patches/series/*version*.patch
		PATCHES+=( "${WORKDIR}"/patches/*.patch )
 	elif use_if_iuse bfs; then
		PATCHES+=( "${WORKDIR}"/patches/${MKV}-sched-bfs-*.patch )
		PATCHES+=( "${WORKDIR}"/patches/hz-{default_1000,no_default_250}.patch )
 	elif use_if_iuse muqss; then
		PATCHES+=( "${WORKDIR}"/patches/*MuQSS*.patch )
	fi
	
	use_if_iuse reiser4 && PATCHES+=( "${DISTDIR}"/${REISER4_SRC} )
	use_if_iuse rt && PATCHES+=( "${DISTDIR}"/${RT_SRC} )
	use_if_iuse toi && PATCHES+=( "${DISTDIR}"/${TOI_SRC} )
	use_if_iuse uksm && PATCHES+=( "${DISTDIR}"/${UKSM_SRC} )
	use_if_iuse optimization && PATCHES+=( "${DISTDIR}"/experimental/*-cpu-optimization*.patch )
	
	epatch "${PATCHES[@]}"
	rm -fr .git*
	sed -e "s,EXTRAVERSION =.*$,EXTRAVERSION = -git," -i Makefile || die
}

fi
