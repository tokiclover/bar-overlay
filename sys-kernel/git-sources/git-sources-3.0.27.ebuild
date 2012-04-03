# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/sys-kernel/git-sources-3.0.27.ebuild, v1.1 2012/04/03 -tclover Exp $

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
EGIT_NOUNPACK="yes"

EGIT_REPO_AUFS="git://aufs.git.sourceforge.net/gitroot/aufs/aufs${KV_MAJOR}-standalone.git"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="aufs bfs fbcondecor ck hz tuxonice"

BFS_FILE=${KV_MAJOR}.${KV_MINOR}-sched-bfs-406.patch
BFS_URI=http://ck.kolivas.org/patches/bfs/${KV_MAJOR}.${KV_MINOR}.0/
CK_VERSION=${KV_MAJOR}.${KV_MINOR}.0-ck1
CK_FILE=${CK_VERSION}-broken-out.tar.bz2
CK_URI="http://ck.kolivas.org/patches/${KV_MAJOR}.${KV_MINOR}/${KV_MAJOR}.${KV_MINOR}/${CK_VERSION}/"
GEN_FILE=genpatches-${KV_MAJOR}.${KV_MINOR}-${K_GENPATCHES_VER}.extras.tar.bz2
TOI_FILE=current-tuxonice-for-${KV_MAJOR}.${KV_MINOR}.patch.bz2
SRC_URI="tuxonice?  ( http://tuxonice.net/files/${TOI_FILE} )
		fbcondecor? ( http://dev.gentoo.org/~mpagano/genpatches/tarballs/${GEN_FILE} )
		bfs?        ( ${BFS_URI}/${BFS_FILE/sched-bfs-406/bfs-406-413} ${CK_URI}/${CK_FILE} )
		ck?         ( ${BFS_URI}/${BFS_FILE/sched-bfs-406/ck1-bfs-406-413} ${CK_URI}/${CK_FILE} )
		hz?         ( ${CK_URI}/${CK_FILE} )
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
		cd ../aufs* && epatch "${FILESDIR}"/aufs-3.0.6-8-loopback.patch && cd ../linux-*
		local AUFS_PREFIX=aufs${KV_MAJOR}-standalone/aufs${KV_MAJOR}
		epatch "${WORKDIR}"/${AUFS_PREFIX}-{kbuild,base,standalone,loopback,proc_map}.patch
	}
	use fbcondecor && epatch "${DISTDIR}"/${GEN_FILE}
	use tuxonice && epatch "${DISTDIR}"/${TOI_FILE}
	if use ck; then
		cd ../patches && epatch "${FILESDIR}"/bfs-406-413.patch && cd ../linux-*
		local AUFS_PREFIX=aufs${KV_MAJOR}-standalone/aufs${KV_MAJOR}
		sed -i -e "s:ck1-version.patch::g" ../patches/series || die "eek!"
		for pch in $(< ../patches/series); do epatch ../patches/$pch || die "eek!"; done
		epatch "${DISTDIR}"/${BFS_FILE/sched-bfs-406/ck1-bfs-406-413}
	else
		use bfs && {
			cd ../patches && epatch "${FILESDIR}"/bfs-406-413.patch && cd ../linux-*
			epatch ../patches/{${BFS_FILE},cpufreq-bfs_tweaks.patch}
			epatch "${DISTDIR}"/${BFS_FILE/sched-bfs-406/bfs-406-413}
		}
		use hz && {
			for pch in $(grep hz ../patches/series); do epatch ../patches/$pch || die "eek!"; done
			epatch ../patches/preempt-desktop-tune.patch || die "eek!"
		}
	fi
	rm -r .git
	sed -e "s:EXTRAVERSION =:EXTRAVERSION = -git:" -i Makefile || die "eek!"
}

pkg_postinst() {
	postinst_sources
}
