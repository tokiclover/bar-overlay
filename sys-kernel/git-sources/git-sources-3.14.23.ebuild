# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-3.14.12.ebuild,v 2.0 2014/07/14 13:45:34 -tclover Exp $

EAPI="5"

ETYPE="sources"
K_DEBLOB_AVAILABLE="1"

inherit kernel-git
detect_version
detect_arch

DESCRIPTION="latest linux-stable.git pulled by git from the stable tree"
HOMEPAGE="http://www.kernel.org"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="aufs bfs ck deblob fbcondecor bfq +gentoo hardened reiser4 +optimization rt toi uksm"
REQUIRED_USE="ck? ( bfs ) bfq? ( optimization )"

CKV="${PV}-git"
OKV="${PV}"
MKV="${KV_MAJOR}.${KV_MINOR}"

AUFS_VER="${MKV}"
BFS_VER="447"
CK_VER="${MKV}-ck1"
GEN_VER="${MKV}-26"
BFQ_VER="${GEN_VER}"
FBC_VER="${GEN_VER}"
GHP_VER="${MKV}.9-1"
RS4_VER="${MKV}.1"
OPT_VER="outdated_versions/linux-3.2+/gcc-4.2+"
RT_VER="${OKV}-rt20"
TOI_VER="${MKV}.9-2014-06-27"
UKSM_VER="${MKV}.ge.10"

EGIT_REPO_AUFS="git://git.code.sf.net/p/aufs/aufs${KV_MAJOR}-standalone.git"
BFS_SRC="${MKV}-sched-bfs-${BFS_VER}.patch"
CK_URI="http://ck.kolivas.org/patches/${KV_MAJOR}.0/${MKV}/${CK_VER}"
CK_SRC="${CK_VER}-broken-out.tar.bz2"
GEN_URI="http://dev.gentoo.org/~mpagano/genpatches/tarballs"
GEN_SRC="genpatches-${GEN_VER}.base.tar.xz"
FBC_SRC="genpatches-${FBC_VER}.extras.tar.xz"
BFQ_SRC="genpatches-${BFQ_VER}.experimental.tar.xz"
GHP_URI="http://dev.gentoo.org/~blueness/hardened-sources/hardened-patches"
GHP_SRC="hardened-patches-${GHP_VER}.extras.tar.bz2"
OPT_URI="https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master"
OPT_FILE="enable_additional_cpu_optimizations_for_gcc.patch"
OPT_SRC="linux-3.2-${OPT_VER##*/}${OPT_FILE:0:19}"
OPT_SRC="${OPT_SRC//+/-}"
RS4_URI="mirror://sourceforge/project/reiser4/reiser4-for-linux-3.x"
RS4_SRC="reiser4-for-${RS4_VER}.patch.gz"
RT_URI="https://www.kernel.org/pub/linux/kernel/projects/rt/${MKV}"
RT_SRC="patch-${RT_VER}.patch.xz"
TOI_URI="http://tuxonice.nigelcunningham.com.au/downloads/all"
TOI_SRC="tuxonice-for-linux-${TOI_VER}.patch.bz2"
UKSM_EXV="0.1.2.3"
UKSM_URI="http://kerneldedup.org/download/uksm/${UKSM_EXV}"
UKSM_SRC="uksm-${UKSM_EXV}-for-v${UKSM_VER}.patch"

SRC_URI="bfs? ( ${CK_URI}/${CK_VER}/${CK_SRC} )
	ck?  ( ${CK_URI}/${CK_VER}/${CK_SRC} )
	bfq? ( ${GEN_URI}/${BFQ_SRC} )
	gentoo? ( ${GEN_URI}/${GEN_SRC} )
	fbcondecor? ( ${GEN_URI}/${FBC_SRC} )
	optimization? ( ${OPT_URI}/${OPT_VER}/${OPT_FILE} -> ${OPT_SRC} )
	hardened? ( ${GHP_URI}/${GHP_SRC} )
	reiser4? ( ${RS4_URI}/${RS4_SRC} )
	toi? ( ${TOI_URI}/${TOI_SRC} )
	uksm? ( ${UKSM_URI}/${UKSM_SRC} )
	rt? ( ${RT_URI}/${RT_SRC} )"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its (unstable and)
experimental nature. If you have any issues, try disabling a few USE flags
that you may suspect being the source of your issues because this ebuild is
based on the latest stable tree."
