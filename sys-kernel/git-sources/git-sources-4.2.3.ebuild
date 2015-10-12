# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-4.2.3.ebuild,v 2.2 2015/10/10 Exp $

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="1"
PATCHSET=(aufs bfq fbcondecor gentoo hardened optimization reiser4)

OKV="${PV}"
MKV="${PV%.*}"
KV_PATCH="${PV##*.}"

EGIT_REPO_AUFS="git://github.com/sfjro/aufs${PV:0:1}-linux.git"
GENTOO_VER="${MKV}-6"
BFQ_VER="${GENTOO_VER}"
FBCONDECOR_VER="${GENTOO_VER}"
HARDENED_VER="${OKV}-2"
REISER4_VER="${MKV}.2"

inherit kernel-git
