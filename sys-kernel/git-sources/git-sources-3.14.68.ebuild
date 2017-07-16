# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: sys-kernel/git-sources/git-sources-3.14.33.ebuild,v 2.2 2015/06/30 Exp $

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
GENTOO_VER="${MKV}-72"
BFQ_VER="${GENTOO_VER}"
FBCONDECOR_VER="${GENTOO_VER}"
HARDENED_VER="${MKV}.51-1"
REISER4_VER="${MKV}.1"
RT_VER="${MKV}.65-rt68"
TOI_VER="${MKV}.67-2016-04-21"
UKSM_VER="${MKV}.ge.10"

inherit kernel-git
