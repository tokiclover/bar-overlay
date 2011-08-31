# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/sys-kernel/git-sources/git-sources-3.0.3-r1.ebuild, v1.2 2011/08/31 -tclover Exp $

EAPI=2

UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="yes"
K_DEBLOB_AVAILABLE=0
#K_WANT_GENPATCHES="extras"
K_GENPATCHES_VER="3"
ETYPE="sources"
CKV="${PVR/-r[0-9]*/-git}"
[ "${PV/_p}" == "${PV}" ] && [ "${PV/_rc}" == "${PV}" ] && OKV="${CKV/-git}"

inherit kernel-2 git-2

detect_version
detect_arch

DESCRIPTION="The very latest stable *-git as pulled by git* of the stable tree"
HOMEPAGE="http://www.kernel.org"
EGIT_REPO_URI=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-${KV_MAJOR}.${KV_MINOR}.y.git
EGIT_COMMIT=d31bf2883542cd3414674238f94123bd1d9c0b9f
EGIT_TAG=v${PV/-r[0-9]*}
EGIT_PROJECT=${PN}
EGIT_NOUNPACK="yes"

EGIT_REPO_AUFS="git://aufs.git.sourceforge.net/gitroot/aufs/aufs${KV_MAJOR}-standalone.git"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="bfs fbcondecor ck hz tuxonice"

CK_VERSION=${KV_MAJOR}.${KV_MINOR}.0-ck1
CK_FILE=${CK_VERSION}-broken-out.tar.bz2
CK_URI="https://www.kernel.org/pub/linux/kernel/people/ck/patches/${KV_MAJOR}.${KV_MINOR}/${CK_VERSION}/"
GEN_FILE=genpatches-${CKV/.${KV_PATCH}*}-${K_GENPATCHES_VER}.extras.tar.bz2
TOI_FILE="current-tuxonice-for-$(get_version_component_range 1-2).patch.bz2"
SRC_URI="tuxonice? ( http://tuxonice.net/files/${TOI_FILE} )
		fbcondecor? ( mirror://${GEN_FILE} )
		bfs? 		( ${CK_URI}/${CK_FILE} )
		ck?			( ${CK_URI}/${CK_FILE} )
		hz? 		( ${CK_URI}/${CK_FILE} )
"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its (unstable and)
experimental nature. If you have any issues, try disabling a few USE flags
that you may suspect being the source of your issues because this ebuild is
based on the latest vanilla (stable) tree."

src_unpack() {
	git-2_src_unpack
	kernel_is gt 3 0 4 && EGIT_BRANCH=aufs${KV_MAJOR}.x-rcN || EGIT_BRANCH=aufs${KV_MAJOR}.${KV_MINOR}
	unset EGIT_COMMIT
	unset EGIT_TAG
	export EGIT_NONBARE=yes
	export EGIT_REPO_URI=${EGIT_REPO_AUFS}
	export EGIT_SOURCEDIR="${WORKDIR}"/aufs${KV_MAJOR}-standalone
	export EGIT_PROJECT=aufs${KV_MAJOR}-standalone
	git-2_src_unpack
	if use bfs || use hz || use ck; then
		unpack ${CK_FILE} || die "eek!"
	fi
}

src_prepare() {
	for f in Documentation fs include/linux/aufs_type.h; do
		cp -pPR "${WORKDIR}"/aufs${KV_MAJOR}-standalone/$f . || die "eek!"
	done
	mv aufs_type.h include/linux/ || die "eek!"
	epatch "${WORKDIR}"/aufs${KV_MAJOR}-standalone/aufs${KV_MAJOR}-{kbuild,base,standalone,loopback,proc_map}.patch
	use fbcondecor && epatch "${DISTDIR}"/${GEN_FILE}
	use tuxonice && epatch "${DISTDIR}"/${TOI_FILE}
	if use ck; then
		sed -i -e "s:ck1-version.patch::g" ../patches/series || die "eek!"
		for pch in $(< ../patches/series); do epatch ../patches/$pch || die "eek!"; done
	else
		use bfs && epatch ../patches/{3.0-sched-bfs-406,cpufreq-bfs_tweaks}.patch || die "eek!"
		if use hz; then
			for pch in $(grep hz ../patches/series); do epatch ../patches/$pch || die "eek!"; done
			epatch ../patches/preempt-desktop-tune.patch || die "eek!"
		fi
	fi
	rm -r .git
	sed -e "s:EXTRAVERSION =:EXTRAVERSION = -git:" -i Makefile || die "eek!"
}

pkg_postinst() {
	postinst_sources
}
