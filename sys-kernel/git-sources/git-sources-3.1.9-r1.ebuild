# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/sys-kernel/git-sources-3.1.0-r1.ebuild, v1.2 2011/11/04 -tclover Exp $

EAPI=2
UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="yes"
K_DEBLOB_AVAILABLE=0
K_WANT_GENPATCHES="extras"
K_GENPATCHES_VER="2"
ETYPE="sources"
CKV=${PV}-git

# only use this if it's not an _rc/_pre release
[ "${PV/_p}" == "${PV}" ] && [ "${PV/_rc}" == "${PV}" ] && OKV="${PV}"
inherit kernel-2 git-2
detect_version
detect_arch

DESCRIPTION="The very latest linux-stable.git, -git as pulled by git of the stable tree"
HOMEPAGE="http://www.kernel.org"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
EGIT_PROJECT=${PN}
EGIT_TAG=v${PV/-r[0-9]*}
#EGIT_COMMIT=b48635635c1a696aea6423ec6c547c8c7bbf7aab
EGIT_NOUNPACK="yes"

EGIT_REPO_AUFS="git://aufs.git.sourceforge.net/gitroot/aufs/aufs${KV_MAJOR}-standalone.git"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="aufs bfs fbcondecor ck hz tuxonice"

BFS_VERSION=414
BFS_FILE=${KV_MAJOR}.${KV_MINOR}-sched-bfs-${BFS_VERSION}.patch
BFS_URI=http://ck.kolivas.org/patches/bfs/${KV_MAJOR}.${KV_MINOR}.0/
CK_VERSION=${KV_MAJOR}.${KV_MINOR}.0-ck2
CK_FILE=${CK_VERSION}-broken-out.tar.bz2
CK_URI="http://ck.kolivas.org/patches/${KV_MAJOR}.0/${KV_MAJOR}.${KV_MINOR}/${CK_VERSION}/"
GEN_FILE=genpatches-${KV_MAJOR}.${KV_MINOR}-${K_GENPATCHES_VER}.extras.tar.bz2
TOI_FILE=current-tuxonice-for-${KV_MAJOR}.0.patch.bz2
SRC_URI="tuxonice? ( http://tuxonice.net/files/${TOI_FILE} )
		fbcondecor? ( http://dev.gentoo.org/~mpagano/genpatches/tarballs/${GEN_FILE} )
		bfs? 		( ${CK_URI}/${CK_FILE} )
		ck?			( ${CK_URI}/${CK_FILE} )
		hz? 		( ${CK_URI}/${CK_FILE} )
"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its (unstable and)
experimental nature. If you have any issues, try disabling a few USE flags
that you may suspect being the source of your issues because this ebuild is
based on the latest mainline (stable) tree."

src_unpack() {
	git-2_src_unpack
	use aufs && {
		EGIT_BRANCH=aufs${KV_MAJOR}.${KV_MINOR}
		unset EGIT_COMMIT
		unset EGIT_TAG
		export EGIT_NONBARE=yes
		export EGIT_REPO_URI=${EGIT_REPO_AUFS}
		export EGIT_SOURCEDIR="${WORKDIR}"/aufs${KV_MAJOR}-standalone
		export EGIT_PROJECT=aufs${KV_MAJOR}-standalone
		git-2_src_unpack
	}
	{ use bfs || use hz || use ck; } && unpack ${CK_FILE} || die "eek!"
}

src_prepare() {
	use aufs && {
		for fle in Documentation fs include/linux/aufs_type.h; do
			cp -pPR "${WORKDIR}"/aufs${KV_MAJOR}-standalone/$fle . || die "eek!"
		done
		mv aufs_type.h include/linux/ || die "eek!"
		local AUFS_PREFIX=aufs${KV_MAJOR}-standalone/aufs${KV_MAJOR}
		epatch "${WORKDIR}"/${AUFS_PREFIX}-{kbuild,base,standalone,loopback,proc_map}.patch
	}
	use fbcondecor && epatch "${DISTDIR}"/${GEN_FILE}
	use tuxonice && epatch "${DISTDIR}"/${TOI_FILE}
	if use ck; then
		sed -i -e "s:ck1-version.patch::g" ../patches/series || die "eek!"
		for pch in $(< ../patches/series); do epatch ../patches/$pch || die "eek!"; done
	else
		use bfs && {
			for pch in $(head -n2 ../patches/series) $(tail -n9 ../patches/series|head -n8)
			do epatch ../patches/$pch; done
		}
		use hz && {
			for pch in $(grep hz ../patches/series)
			do epatch ../patches/$pch || die "eek!"; done
			epatch ../patches/preempt-desktop-tune.patch || die "eek!"
		}
	fi
	epatch "${FILESDIR}"/mg-aspm.patch || die "eek!"
	rm -r .git
	sed -e "s:EXTRAVERSION =:EXTRAVERSION = -git:" -i Makefile || die "eek!"
}

pkg_postinst() {
	postinst_sources
}
