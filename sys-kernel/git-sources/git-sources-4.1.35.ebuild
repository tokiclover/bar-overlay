# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: sys-kernel/git-sources/git-sources-4.1.10.ebuild,v 2.2 2015/10/10 Exp $

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="1"
PATCHSET=(aufs bfs bfq ck fbcondecor gentoo optimization reiser4 rt toi)

OKV="${PV}"
MKV="${PV%.*}"
KV_PATCH="${PV##*.}"

BFS_VER="463"
CK_VER="${MKV}-ck2"
GENTOO_VER="${MKV}-25"
FBCONDECOR_VER="${GENTOO_VER}"
REISER4_VER="${MKV}.7"
RT_VER="${OKV}-rt40"
TOI_VER="${MKV}.22-2016-04-21"

inherit kernel-git
