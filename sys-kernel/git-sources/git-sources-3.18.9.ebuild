# Copyright 1999-2015 Gentoo Foundation
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
HARDENED_VER="${OKV}-1"
REISER4_VER="${MKV}.6"
RT_VER="${OKV}-rt5"
RT_URI="https://www.kernel.org/pub/linux/kernel/projects/rt/${MKV}/older"
TOI_VER="${OKV}-2015-03-14"
UKSM_VER="${MKV}"

inherit kernel-git
