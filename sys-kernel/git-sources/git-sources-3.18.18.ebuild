# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-3.18.6.ebuild,v 2.2 2015/06/30 $

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="1"
PATCHSET=(aufs bfs bfq ck fbcondecor gentoo hardened optimization reiser4 rt toi uksm)

OKV="${PV}"
MKV="${PV%.*}"
KV_PATCH="${PV##*.}"

AUFS_VER="${MKV}.1+"
BFS_VER="460"
CK_VER="${MKV}-ck1"
GENTOOTOO_VER="${MKV}-${KV_PATCH}"
BFQ_VER="${GENTOOTOO_VER}"
FBCONDECORONDECOR_VER="${GENTOOTOO_VER}"
HARDENED_VER="${MKV}.9-1"
REISER4_VER="${MKV}.6"
RT_VER="${MKV}.17-rt14"
TOI_VER="${MKV}.16-2015-06-17"
UKSM_VER="${MKV}"

inherit kernel-git
