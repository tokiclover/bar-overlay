# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-3.14.32.ebuild,v 2.2 2015/06/30 $

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="1"
PATCHSET=(aufs bfs ck fbcondecor bfq gentoo hardened reiser4 optimization rt toi uksm)

OKV="${PV}"
MKV="${PV%.*}"
KV_PATCH="${PV##*.}"

AUFS_VER="${MKV}.21+"
BFS_VER="447"
CK_VER="${MKV}-ck1"
GENTOO_VER="${MKV}-64"
BFQ_VER="${GENTOO_VER}"
FBCONDECOR_VER="${GENTOO_VER}"
HARDENED_VER="${MKV}.51-1"
REISER4_VER="${MKV}.1"
RT_VER="${MKV}.57-rt58"
TOI_VER="${OKV}-2015-12-18"
UKSM_VER="${MKV}.ge.10"

inherit kernel-git
