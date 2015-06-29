# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-3.4.97.ebuild,v 2.2 2015/06/30 13:45:34 Exp $

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="1"
PATCHSET=(aufs bfs ck fbcondecor gentoo hardened rt toi uksm)

OKV="${PV}"
MKV="${PV%.*}"
KV_PATCH="${PV##*.}"

BFS_VER="424"
CK_VER="${MKV}-ck3"
GENTOO_VER="${MKV}-87"
FBCONDECOR_VER="${GENTOO_VER}"
HARDENED_VER="${MKV}.7-1"
RT_VER="${OKV}-rt133"
REISER4_VER="${MKV}"
TOI_VER="${OKV}-2015-04-18"
UKSM_VER="${MKV}.ge.96"

inherit kernel-git
