# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-3.2.64.ebuild,v 2.2 2015/06/30 13:45:34 Exp $

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="1"
PATCHSET=(aufs bfs ck fbcondecor gentoo hardened rt toi uksm)

OKV="${PV}"
MKV="${PV%.*}"
KV_PATCH="${PV##*.}"

BFS_VER="416"
CK_VER="${MKV}-ck1"
GENTOO_VER="${MKV}-39"
FBCONDECOR_VER="${GENTOO_VER}"
HARDENED_VER="${OKV}-4"
RT_VER="${OKV}-rt101"
TOI_VER="${OKV}-2015-05-11"
UKSM_VER="${MKV}.ge.60"

inherit kernel-git
