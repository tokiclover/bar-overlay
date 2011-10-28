# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/sys-kernel/git-sources-3.0.6-r1.ebuild, v1.1 2011/10/27 -tclover Exp $

EAPI=2

UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="yes"
K_DEBLOB_AVAILABLE=0
use fbcondecor && K_WANT_GENPATCHES="extras"
K_GENPATCHES_VER="7"
ETYPE="sources"
CKV="${PVR/-r[0-9]*/-git}"
[ "${PV/_p}" == "${PV}" ] && [ "${PV/_rc}" == "${PV}" ] && OKV="${CKV/-git}"

inherit kernel-2 git-2

detect_version
detect_arch

DESCRIPTION="The very latest linux-stable.git stable tree, -git as pulled by git"
HOMEPAGE="http://www.kernel.org"
EGIT_REPO_URI=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
EGIT_COMMIT=97596c34030ed28657ccafddb67e17a03890b90a
EGIT_TAG=v${PV/-r[0-9]*}
EGIT_PROJECT=${PN}
EGIT_NOUNPACK="yes"

EGIT_REPO_AUFS="git://aufs.git.sourceforge.net/gitroot/aufs/aufs${KV_MAJOR}-standalone.git"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="aufs bfs fbcondecor hz tuxonice"

BFS_VERSION=413
BFS_FILE=${KV_MAJOR}.${KV_MINOR:-0}-sched-bfs-${BFS_VERSION}.patch
BFS_URI=http://ck.kolivas.org/patches/bfs/${KV_MAJOR}.${KV_MINOR}.0/
GEN_FILE=genpatches-$(get_version_component_range 1-2)-${K_GENPATCHES_VER}.extras.tar.bz2
TOI_FILE="current-tuxonice-for-$(get_version_component_range 1-2).patch.bz2"
SRC_URI="tuxonice?  ( http://tuxonice.net/files/${TOI_FILE} )
		bfs?        ( ${BFS_URI}/${BFS_FILE} )
		fbcondecor? ( mirror://${GEN_FILE} )
"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its (unstable and)
experimental nature. If you have any issues, try disabling a few USE flags
that you may suspect being the source of your issues because this ebuild is
based on the latest vanilla (stable) tree."

src_unpack() {
	git-2_src_unpack
	use aufs && {
		kernel_is gt 3 1 0 && EGIT_BRANCH=aufs${KV_MAJOR}.x-rcN || EGIT_BRANCH=aufs${KV_MAJOR}.${KV_MINOR}
		unset EGIT_COMMIT
		unset EGIT_TAG
		export EGIT_NONBARE=yes
		export EGIT_REPO_URI=${EGIT_REPO_AUFS}
		export EGIT_SOURCEDIR="${WORKDIR}"/aufs${KV_MAJOR}-standalone
		export EGIT_PROJECT=aufs${KV_MAJOR}-standalone
		git-2_src_unpack
	}
}

src_prepare() {
	use aufs && {
		for fle in Documentation fs include/linux/aufs_type.h; do
			cp -pPR "${WORKDIR}"/aufs${KV_MAJOR}-standalone/$fle . || die "eek!"
		done
		mv aufs_type.h include/linux/ || die "eek!"
		epatch "${WORKDIR}"/aufs${KV_MAJOR}-standalone/aufs${KV_MAJOR}-{kbuild,base,standalone,loopback,proc_map}.patch
	}
	use fbcondecor && epatch "${DISTDIR}"/${GEN_FILE}
	use tuxonice && epatch "${DISTDIR}"/${TOI_FILE}
	use bfs && epatch "${DISTDIR}"/${BFS_FILE}
	use hz && epatch "${FILESDIR}"/hz-preempt-bfs.patch.bz2
	rm -r .git
	sed -e "s:EXTRAVERSION =:EXTRAVERSION = -git:" -i Makefile || die "eek!"
}

pkg_postinst() {
	postinst_sources
}
