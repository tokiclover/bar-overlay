# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-4.0.2.ebuild,v 2.0 2015/02/20 13:45:34 -tclover Exp $

EAPI="5"

ETYPE="sources"
K_DEBLOB_AVAILABLE="1"

inherit kernel-git
detect_version
detect_arch

DESCRIPTION="latest linux-stable.git pulled by git from the stable tree"
HOMEPAGE="http://www.kernel.org"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="aufs bfs bfq ck fbcondecor +gentoo hardened +optimization"
REQUIRED_USE="ck? ( bfs ) bfq? ( optimization )"

CKV="${PV}-git"
OKV="${PV}"
MKV="${KV_MAJOR}.${KV_MINOR}"

EGIT_REPO_AUFS="git@github.com:sfjro/aufs4-standalone.git"
BFS_VER="462"
CK_VER="${MKV}-ck1"
GEN_VER="${MKV}-${KV_PATCH}"
BFQ_VER="${GEN_VER}"
FBC_VER="${GEN_VER}"
GHP_VER="${MKV}.1-1"

BFS_SRC="${MKV}-sched-bfs-${BFS_VER}.patch"
CK_SRC="${CK_VER}-broken-out.tar.bz2"
GEN_SRC="genpatches-${GEN_VER}.base.tar.xz"
BFQ_SRC="genpatches-${BFQ_VER}.experimental.tar.xz"
FBC_SRC="genpatches-${FBC_VER}.extras.tar.xz"
GHP_SRC="hardened-patches-${GHP_VER}.extras.tar.bz2"

SRC_URI="bfs? ( ${CK_URI}/${CK_SRC} )
	ck?  ( ${CK_URI}/${CK_VER}/${CK_SRC} )
	bfq? ( ${GEN_URI}/${BFQ_SRC} )
	gentoo? ( ${GEN_URI}/${GEN_SRC} )
	fbcondecor? ( ${GEN_URI}/${FBC_SRC} )
	optimization? ( ${OPT_URI}/${OPT_VER}/${OPT_FILE} -> ${OPT_SRC} )
	hardened? ( ${GHP_URI}/${GHP_SRC} )"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its (unstable and)
experimental nature. If you have any issues, try disabling a few USE flags
that you may suspect being the source of your issues because this ebuild is
based on the latest stable tree."
