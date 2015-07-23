# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-3.19.5.ebuild,v 2.2 2015/06/30 $

EAPI="5"
ETYPE="sources"
K_DEBLOB_AVAILABLE="1"
PATCHSET=(aufs bfq fbcondecor gentoo optimization rt)

OKV="${PV}"
MKV="${PV%.*}"
KV_PATCH="${PV##*.}"

GENTOO_VER="${MKV}-6"
FBCONDECOR_VER="${GENTOO_VER}"
RT_VER="${MKV}.2-rt1"

inherit kernel-git
