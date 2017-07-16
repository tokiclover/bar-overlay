# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: sys-kernel/git-sources/git-sources-3.12.37.ebuild,v 2.2 2015/06/30 $

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="1"
PATCHSET=(aufs bfs bfq ck fbcondecor gentoo hardened reiser4 optimization rt toi uksm)

OKV="${PV}"
MKV="${PV%.*}"
KV_PATCH="${PV##*.}"

BFS_VER="444"
CK_VER="${MKV}-ck2"
GENTOO_VER="${MKV}-54"
BFQ_VER="${GENTOO_VER}"
FBCONDECOR_VER="${GENTOO_VER}"
HARDENED_VER="${MKV}.8-2"
RT_VER="${MKV}.57-rt77"
REISER4_VER="${MKV}.6"
TOI_VER="${OKV}-2016-04-21"
UKSM_VER="${MKV}.ge.23"

inherit kernel-git
