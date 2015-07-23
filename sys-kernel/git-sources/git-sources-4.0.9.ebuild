# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-4.0.2.ebuild,v 2.2 2015/06/30 $

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="1"
PATCHSET=(aufs bfs bfq ck fbcondecor gentoo hardened optimization rt reiser4 toi)

OKV="${PV}"
MKV="${PV%.*}"
KV_PATCH="${PV##*.}"

BFS_VER="462"
CK_VER="${MKV}-ck1"
GENTOO_VER="${MKV}-${KV_PATCH}"
BFQ_VER="${GENTOO_VER}"
FBCONDECOR_VER="${GENTOO_VER}"
HARDENED_VER="${MKV}.8-1"
REISER4_VER="${MKV}.4"
RT_VER="${MKV}.8-rt6"
TOI_VER="${OKV}-2015-07-23"

inherit kernel-git
