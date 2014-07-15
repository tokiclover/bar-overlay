# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: sys-kernel/git-sources/git-sources-3.10.47.ebuild,v 2.0 2014/07/14 13:45:34 -tclover Exp $

EAPI=5

ETYPE="sources"
K_DEBLOB_AVAILABLE="1"

inherit kernel-git
detect_version
detect_arch

DESCRIPTION="latest linux-stable.git pulled by git from the stable tree"
HOMEPAGE="http://www.kernel.org"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="aufs bfs bfq ck deblob fbcondecor +gentoo hardened reiser4 optimization rt toi uksm"

BFS_VER="440"
CK_VER="${MKV}-ck1"
GEN_VER="${MKV}-55"
GHP_VER="${MKV}.10-2"
RT_VER="${OKV}-rt49"
RS4_VER="${MKV}"
TOI_VER="${MKV}.45-2014-06-27"
UKSM_VER="${MKV}.ge.46"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its (unstable and)
experimental nature. If you have any issues, try disabling a few USE flags
that you may suspect being the source of your issues because this ebuild is
based on the latest stable tree."
