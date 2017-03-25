# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-4.9.16.ebuild,v 2.2 2015/10/10 Exp $

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="1"
PATCHSET=(aufs bfq ck fbcondecor gentoo hardened muqss reiser4 rt)

OKV="${PV}"
MKV="${PV%.*}"
KV_PATCH="${PV##*.}"

CK_VER="${MKV}-ck1"
CK_SRC=${CK_VER}-broken-out.tar.xz
GENTOO_VER="${MKV}-17"
FBCONDECOR_VER="${GENTOO_VER}"
HARDENED_VER="${OKV}-1"
REISER4_VER="${MKV}.3"
RT_VER="${MKV}.13-rt12"

inherit kernel-git
