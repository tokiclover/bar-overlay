# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-3.10.69.ebuild,v 2.2 2015/06/30 $

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="1"
PATCHSET=(aufs bfs bfq ck fbcondecor gentoo hardened reiser4 optimization rt toi uksm)

OKV="${PV}"
MKV="${PV%.*}"
KV_PATCH="${PV##*.}"

AUFS_VER="${MKV}.x"
BFS_VER="440"
CK_VER="${MKV}-ck1"
GENTOO_VER="${MKV}-87"
BFQ_VER="${GENTOO_VER}"
FBCONDECOR_VER="${GENTOO_VER}"
HARDENED_VER="${MKV}.11-1"
RT_VER="${MKV}.82-rt89"
REISER4_VER="${MKV}"
TOI_VER="${MKV}.80-2015-06-17"
UKSM_VER="${MKV}.ge.46"

inherit kernel-git
