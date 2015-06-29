# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: eclass/kernel-git.eclass,v 2.0 2015/06/30 20:33:34 -tclover Exp $

# @ECLASS: kernel-git.eclass
# @MAINTAINER: tclover@bar-overlay
# @DESCRIPTION: portage eclass base functions used by 
# sys-kernel/git-sources::bar ebuilds

inherit kernel-2 git-2
detect_version
detect_arch
SRC_URI+="
	${KERNEL_BASE_URI}/linux-${MKV}.tar.xz
	${KERNEL_BASE_URI}/patch-${OKV}.xz"

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

has ck "${PATCHSET[@]}" &&
REQUIRED_USE="${REQUIRED_USE}
	ck? ( bfs )"

RDEDEPEND="hardened? ( sys-apps/paxctl sys-apps/gradm )"
DEPEND="${RDEPEND}"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its (unstable and)
experimental nature. If you have any issues, try disabling a few USE flags
that you may suspect being the source of your issues because this ebuild is
based on the latest stable tree."

# @ECLASS-VARIABLE: OKV
# @DESCRIPT: kernel version release
:	${OKV:=${PV}}
# @ECLASS-VARIABLE: MKV
# @DESCRIPT: *major* kernel version release
:	${MKV:=${PV%.*}}

:	${KV_MAJOR:=${MKV%.*}}
:	${KV_MINOR:=${MKV#*.}}
:	${KV_PATCH:=${PV##*.}}

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
:	${BFS_PATCH:=${MKV}-sched-bfs-${BFS_VER}.patch}
# @ECLASS-VARIABLE: BFS_BASE_PATCH
# @DESCRIPTION: bfs base patch to patch the unpacked files

# @ECLASS-VARIABLE: BFS_EXTRA_PATCH
# @DESCRIPTION: bfs extra patch included in ck broken-out archive

# @ECLASS-VARIABLE: CK_VER
# @DESCRIPTION: -ck patchset version string
# @ECLASS-VARIABLE: CK_URI
# @DESCRIPTION: -ck patchset src URI
:	${CK_URI:="http://ck.kolivas.org/patches/${KV_MAJOR}.0/${MKV}"}
:	${BFS_URI:=${CK_URI}}
# @ECLASS-VARIABLE: CK_SRC
# @DESCRIPTION: -ck src file
:	${CK_SRC:=${CK_VER}-broken-out.tar.bz2}
:	${BFS_SRC:=${CK_SRC}}

# @ECLASS-VARIABLE: GENTOO_VER
# @DESCRIPTION: gentoo base patchset version string
:	${GENTOO_VER:=${MKV}-1}
# @ECLASS-VARIABLE: GENTOO_URI
# @DESCRIPTION: gentoo patchset src URI
:	${GENTOO_URI:="http://dev.gentoo.org/~mpagano/genpatches/tarballs"}
# @ECLASS-VARIABLE: GENTOO_SRC
# @DESCRIPTION: gentoo base src file
:	${GENTOO_SRC:=genpatches-${GENTOO_VER}.base.tar.xz}

# @ECLASS-VARIABLE: FBCONDECOR_VER
# @DESCRIPTION: fbcondecor version string: genpatches extras version
:	${FBCONDECOR_VER:=${GENTOO_VER}}
# @ECLASS-VARIABLE: FBCONDECOR_SRC
# @DESCRIPTION: gentoo extras src file
:	${FBCONDECOR_SRC:=genpatches-${FBCONDECOR_VER}.extras.tar.xz}
:	${FBCONDECOR_URI:=${GENTOO_URI}}

# @ECLASS-VARIABLE: BFQ_VER
# @DESCRIPTION: BFQ version string: genpatches experimental version
:	${BFQ_VER:=${GENTOO_VER}}
# @ECLASS-VARIABLE: BFQ_SRC
# @DESCRIPTION: gentoo experimental src file
:	${BFQ_SRC:=genpatches-${BFQ_VER}.experimental.tar.xz}
:	${BFQ_URI:=${GENTOO_URI}}

# @ECLASS-VARIABLE: HARDENED_VER
# @DESCRIPTION: gentoo hardened uni patch version string
:	${HARDENED_VER:=${OKV}-1}
# @ECLASS-VARIABLE: HARDENED_URI
# @DESCRIPTION: gentoo hardened uni patch src URI
:	${HARDENED_URI:="http://dev.gentoo.org/~blueness/hardened-sources/hardened-patches"}
# @ECLASS-VARIABLE: HARDENED_SRC
# @DESCRIPTION: gentoo hardened uni patch src file
:	${HARDENED_SRC:=hardened-patches-${HARDENED_VER}.extras.tar.bz2}

# @ECLASS-VARIABLE: OPTIMIZATION_VER
# @DESCRIPTION: cpu optimization kind of *version* string
:	${OPTIMIZATION_VER:=${BFQ_VER}}
# @ECLASS-VARIABLE: OPTIMIZATION_URI
# @DESCRIPTION: cpu optimization src URI
:	${OPTIMIZATION_URI:=${BFQ_URI}}
# @ECLASS-VARIABLE: OPTIMIZATION_SRC
# @DESCRIPTION: cpu optimization src file
:	${OPTIMIZATION_SRC:=${BFQ_SRC}}

# @ECLASS-VARIABLE: REISER4_VER
# @DESCRIPTION: reiser4 version string
:	${REISER4_VER:=${OKV}}
# @ECLASS-VARIABLE: REISER4_URI
# @DESCRIPTION: reiser4 src URI
:	${REISER4_URI:="mirror://sourceforge/project/reiser4/reiser4-for-linux-3.x"}
# @ECLASS-VARIABLE: REISER4_SRC
# @DESCRIPTION: reiser4 src file
:	${REISER4_SRC:=reiser4-for-${REISER4_VER}.patch.gz}

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

# @ECLASS-VARIABLE: UKSM_REV
# @DESCRIPTION: uksm version string
:	${UKSM_REV:=0.1.2.3}
# @ECLASS-VARIABLE: UKSM_URI
# @DESCRIPTION: uksm src URI
:	${UKSM_URI:="http://kerneldedup.org/download/uksm/${UKSM_REV}"}
# @ECLASS-VARIABLE: UKSM_VER
# @DESCRIPTION: uksm base version string
# @ECLASS-VARIABLE: UKSM_SRC
# @DESCRIPTION: uksm src file
:	${UKSM_SRC:=uksm-${UKSM_REV}-for-v${UKSM_VER}.patch}

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
src_patch_unpack() {
	(( ${#} < 1 )) && return "${?}"
	local dir="${WORKDIR}"/${2} n=/dev/null
	mkdir -p "${dir}"
	pushd "${dir}" >${n}
	unpack ${1}
	popd >${n}
}

# @FUNCTION: linux-git_src_unpack
kernel-git_src_unpack() {
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
	if use_if_iuse bfs || use_if_iuse ck; then
		unpack ${CK_SRC}
	fi
	use_if_iuse hardened   && unpack ${HARDENED_SRC}
	use_if_iuse gentoo     && src_patch_unpack ${GENTOO_SRC} base
	use_if_iuse fbcondecor && src_patch_unpack ${FBCONDECOR_SRC} extras
	use_if_iuse bfq        && src_patch_unpack ${BFQ_SRC} experimental
}

# @FUNCTION: kernel-git_src_prepare
kernel-git_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	epatch "${WORKDIR}"/patch-${OKV}
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

	use_if_iuse hardened   && epatch "${WORKDIR}"/${MKV}*/*.patch
	use_if_iuse gentoo     && epatch "${WORKDIR}"/base/*.patch
	use_if_iuse fbcondecor && epatch "${WORKDIR}"/extras/*.patch
	use_if_iuse bfq        && epatch "${WORKDIR}"/experimental/*BFQ*.patch

	if use_if_iuse ck || use_if_iuse bfs; then
		[[ -n "${BFS_BASE_PATCH}" ]] &&
			epatch "${WORKDIR}"/patches/${BFS_BASE}
	fi
	if use_if_iuse ck; then
		sed -e "/ck.*-version.patch/d" \
			-i "${WORKDIR}"/patches/series || die
		while read line; do
			epatch "${WORKDIR}"/patches/$line
		done <"${WORKDIR}"/patches/series
 	elif use_if_iuse bfs; then
		epatch "${WORKDIR}"/patches/${BFS_PATCH}
		epatch "${WORKDIR}"/patches/hz-{default_1000,no_default_250}.patch
		[[ -n "${BFS_EXTRA_PATCH}" ]] &&
			epatch "${WORKDIR}"/patches/${BFS_EXTRA}
	fi
	
	use_if_iuse reiser4 && epatch "${DISTDIR}"/${REISER4_SRC}
	use_if_iuse rt && epatch "${DISTDIR}"/${RT_SRC}
	use_if_iuse toi && epatch "${DISTDIR}"/${TOI_SRC}
	use_if_iuse uksm && epatch "${DISTDIR}"/${UKSM_SRC}
	use_if_iuse optimization && epatch "${DISTDIR}"/experimental/*-cpu-optimization*.patch
	
	rm -fr .git*
	sed -e "s,EXTRAVERSION =.*$,EXTRAVERSION = -git," -i Makefile || die
}
