# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: eclass/kernel-git.eclass,v 0.1 2014/07/14 19:33:34 -tclover Exp $

# @ECLASS: kernel-git.eclass
# @MAINTAINER: tclover@bar-overlay
# @DESCRIPTION: portage eclass base functions used by 
# sys-kernel/git-sources::bar ebuilds

inherit kernel-2 git-2

CKV=${PV}-git
OKV=${PV}

EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
EGIT_COMMIT=v${PV/%.0}
EGIT_NOUNPACK="yes"

#IUSE="aufs bfs bfq ck fbcondecor +gentoo hardened reiser4 rt toi uksm"

REQUIRED_USE="ck? ( bfs )"
KEYWORDS="-* ~x86 ~amd64"

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
:	${BFS_VER:=}
# @ECLASS-VARIABLE: BFS_SRC
# @DESCRIPTION: BFS src file
:	${BFS_SRC:=${MKV}-sched-bfs-${BFS_VER}.patch}
# @ECLASS-VARIABLE: BFS_EXTRA_PATCH
# @DESCRIPTION: bfs extra patched included in ck broken-out archive

## @ECLASS-VARIABLE: BLD_VER
## @DESCRIPTION: bld version string
#:	${BLD_VER:=${MKV}.0}
## @ECLASS-VARIABLE: BLD_URI
## @DESCRIPTION: bld src URI
#:	${BLD_URI:="https://bld.googlecode.com/"}
## @ECLASS-VARIABLE: BLD_SRC
## @DESCRIPTION: BLD src file
#:	${BLD_SRC:=bld-${MKV}.0.patch}

# @ECLASS-VARIABLE: CK_VER
# @DESCRIPTION: -ck patchset version string
:	${CK_VER:=${MKV}-ck1}
# @ECLASS-VARIABLE: CK_URI
# @DESCRIPTION: -ck patchset src URI
:	${CK_URI:="http://ck.kolivas.org/patches/${KV_MAJOR}.0/${MKV}/${CK_VER}/"}
# @ECLASS-VARIABLE: CK_SRC
# @DESCRIPTION: -ck src file
:	${CK_SRC:=${CK_VER}-broken-out.tar.bz2}

# @ECLASS-VARIABLE: GEN_VER
# @DESCRIPTION: gentoo base patchset version string
:	${GEN_VER:=${MKV}-1}
# @ECLASS-VARIABLE: GEN_URI
# @DESCRIPTION: gentoo patchset src URI
:	${GEN_URI:="http://dev.gentoo.org/~mpagano/genpatches/tarballs/"}
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
:	${GHP_VER:=${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}-1}
# @ECLASS-VARIABLE: GHP_URI
# @DESCRIPTION: gentoo hardened uni patch src URI
:	${GHP_URI:="http://dev.gentoo.org/~blueness/hardened-sources/hardened-patches/"}
# @ECLASS-VARIABLE: GHP_SRC
# @DESCRIPTION: gentoo hardened uni patch src file
:	${GHP_SRC:=hardened-patches-${GHP_VER}.extras.tar.bz2}

# @ECLASS-VARIABLE: RS4_VER
# @DESCRIPTION: reiser4 version string
:	${RS4_VER:=${OKV}}
# @ECLASS-VARIABLE: RS4_URI
# @DESCRIPTION: reiser4 src URI
:	${RS4_URI:="http://sourceforge.net/projects/reiser4/files/reiser4-for-linux-3.x/"}
# @ECLASS-VARIABLE: RS4_SRC
# @DESCRIPTION: reiser4 src file
:	${RS4_SRC:=reiser4-for-${OKV}.patch.gz}

# @ECLASS-VARIABLE: RT_URI
# @DESCRIPTION: -rt version string
:	${RT_VER:=${OKV}-rt1}
# @ECLASS-VARIABLE: RT_URI
# @DESCRIPTION: -rt src URI
:	${RT_URI:="https://www.kernel.org/pub/linux/kernel/projects/rt/${MKV}/"}
# @ECLASS-VARIABLE: RT_SRC
# @DESCRIPTION: -rt src file
:	${RT_SRC:=patches-${RT_VER}.tar.xz}

# @ECLASS-VARIABLE: TOI_VER
# @DESCRIPTION: tuxonice version string
:	${TOI_VER:=}
# @ECLASS-VARIABLE: TOI_URI
# @DESCRIPTION: tuxonice URI
:	${TOI_URI:="http://tuxonice.nigelcunningham.com.au/downloads/all/"}
# @ECLASS-VARIABLE: TOI_SRC
# @DESCRIPTION: tuxonice src file
:	${TOI_SRC:=tuxonice-for-linux-${TOI_VER}.patch.bz2}

# @ECLASS-VARIABLE: UKSM_VER
# @DESCRIPTION: uksm version string
:	${UKSM_VER:=0.1.2.3}
# @ECLASS-VARIABLE: UKSM_URI
# @DESCRIPTION: uksm src URI
:	${UKSM_URI:="http://kerneldedup.org/download/uksm/${UKSM_VER}"}
# @ECLASS-VARIABLE: UKSM_EXV
# @DESCRIPTION: uksm extra version
# @ECLASS-VARIABLE: UKSM_SRC
# @DESCRIPTION: uksm src file
:	${UKSM_SRC:=uksm-${UKSM_VER}-for-v${UKSM_EXV}.patch}

SRC_URI="
	bfs? ( ${CK_URI}/${CK_SRC} )
	ck?  ( ${CK_URI}/${CK_SRC} )
	bfq? ( ${GEN_URI}/${BFQ_SRC} )
	gentoo? ( ${GEN_URI}§${GEN_SRC} )
	fbcondecor? ( ${GEN_URI}/${FBC_SRC} )
	hardened? ( ${GHP_URI}/${GHP_SRC} )
	reiser4? ( ${RS4_URI}/${RS4_SRC} )
	toi? ( ${TOI_URI}/${TOI_SRC} )
	uksm? ( ${UKSM_URI}/${UKSM_SRC} )
	rt? ( ${RT_URI}/${RT_SRC} )
"

# @FUNCTION: linux-git_src_unpack
linux-git_src_unpack() {
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
}

# @FUNCTION: kernel-git_src_prepare
kernel-git_src_prepare() {
	epatch_user

	if use_if_iuse aufs; then
		local a=aufs${KV_MAJOR}-standalone
		local b=a/aufs${KV_MAJOR} d
		for d in Documentation fs include; do
			cp -a "${WORKDIR}"/${a}/${d} "${S}" || die
		done
		epatch "${WORKDIR}"/${b}-{kbuild,base,standalone,loopback,proc_map}.patch
		[[ -n "${AUFS_EXTRA_PATCH}" && epatch "${WORKDIR}"/${a}/${AUFS_EXTRA_PATCH}
	fi

	if use_if_iuse ck; then
		sed -e "d/ck1-version.patch/" \
			-i "${WORKDIR}"/patches/series || die
		while read line; do
			epatch "${WORKDIR}"/patches/$line
		done <"${WORKDIR}"/patches/series
 	elif use_if_iuse bfs; then
		epatch "${WORKDIR}"/patches/${BFS_SRC}
		epatch "${WORKDIR}"/patches/hz-{default_1000,no_default_250}.patch
		[[ -n "${BFS_EXTRA_PATCH}" && epatch "${WORKDIR}"/patches/${BFS_EXTRA_PATCH}
	fi
	
	use_if_iuse gentoo && epatch "${DISTDIR}"/${GEN_SRC}
	use_if_iuse hardened && epatch "${DISTDIR}"/${GHP_SRC}
	use_if_iuse fbcondecor && epatch "${DISTDIR}"/${FBC_SRC}
	use_if_iuse bfq && epatch "${DISTDIR}"/${BFQ_SRC}
	use_if_iuse reiser4 && epatch "${DISTDIR}"/${RS4_SRC}
	use_if_iuse bfq && epatch "${DISTDIR}"/${BFQ_SRC}
	use_if_iuse rt && epatch "${DISTDIR}"/${RT_SRC}
	use_if_iuse toi && epatch "${DISTDIR}"/${TOI_SRC}
	use_if_iuse uksm && epatch "${DISTDIR}"/${UKSM_SRC}
	
	rm -fr .git*
	sed -e "s,EXTRAVERSION =.*$,EXTRAVERSION = -git,"
	    -i Makefile || die
}
