# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $DISTDIR/git-src/bar-overlay/portage/sys-kernel/git-sources/git-sources-3.0.1-r1.ebuild, v1.4 2011/08/11 Exp $

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

# only use this if it's not an _rc/_pre release
[ "${PV/_p}" == "${PV}" ] && [ "${PV/_rc}" == "${PV}" ] && OKV="${PV}"
inherit kernel-2 git-2
detect_version
detect_arch

DESCRIPTION="The very latest stable (-git version as pulled by git) of the Linux kernel"
HOMEPAGE="http://www.kernel.org"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
#EGIT_COMMIT="94ed5b4788a7cdbe68bc7cb8516972cbebdc8274"
EGIT_PROJECT=${PN}
EGIT_TAG=v${KV_MAJOR}.${KV_MINOR}
EGIT_NOUNPACK="yes"

EGIT_REPO_AUFS="git://aufs.git.sourceforge.net/gitroot/aufs/aufs2-standalone.git"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="bfs fbcondecor ck hz tuxonice"

GEN_FILE=genpatches-${PV/1_rc[0-9]*/0}-${K_GENPATCHES_VER}.extras.tar.bz2
CK_BFILE=${PV/1_rc[0-9]*/0.0-ck1}-broken-out.tar.bz2
CK_URI="https://www.kernel.org/pub/linux/kernel/people/ck/patches/${PV/1_rc[0-9]*/0}/${PV/1_rc[09-]*/0.0-ck1}/"
TOI_FILE="current-tuxonice-for-${PV/1_rc[0-9]*/0}.patch.bz2"
SRC_URI="tuxonice? ( http://tuxonice.net/files/${TOI_FILE} )
		fbcondecor? ( mirror://${GEN_FILE} )
		bfs? 		( ${CK_URI}/${CK_BFILE} )
		hz? 		( ${CK_URI}/${CK_BFILE} )
		ck? 		( ${CK_URI}/${CK_BFILE} )
"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its (unstable and)
experimental nature. If you have any issues, try disabling a few USE flags
that you may suspect being the source of your issues because this ebuild is
based on the latest vanilla (stable) tree."

src_unpack() {
	git-2_src_unpack
	if [[ ${KV_MAJOR} -le 3 ]]; then EGIT_BRANCH=aufs2.1
	else EGIT_BRANCH=aufs2.1-${KV_PATCH}; fi
	unset EGIT_COMMIT
	unset EGIT_TAG
	export EGIT_NONBARE=yes
	export EGIT_REPO_URI=${EGIT_REPO_AUFS}
	export EGIT_SOURCEDIR="${WORKDIR}"/aufs2-standalone
	export EGIT_PROJECT=aufs2-standalone
	git-2_src_unpack
	if use bfs || use hz || use ck; then
		unpack ${CK_BFILE} || die "eek!"
	fi
}

src_prepare() {
	for i in Documentation fs include/linux/aufs_type.h; do
		cp -pPR "${WORKDIR}"/aufs2-standalone/$i . || die "eek!"
	done
	mv aufs_type.h include/linux/ || die "eek!"
	epatch "${WORKDIR}"/aufs2-standalone/{aufs2-{kbuild,base,standalone},loopback,proc_map}.patch
	use fbcondecor && epatch "${DISTDIR}"/${GEN_FILE}
	use tuxonice && epatch "${DISTDIR}"/${TOI_FILE}
	if use ck; then
		sed -i -e "s:ck1-version.patch::g" ../patches/series || die "eek!"
		for i in $(< ../patches/series); do epatch ../patches/$i || die "eek!"; done
	else
		use bfs && epatch ../patches/{3.0-sched-bfs-406,cpufreq-bfs_tweaks}.patch || die "eek!"
		if use hz; then
			for i in $(grep hz ../patches/series); do epatch ../patches/$i || die "eek!"; done
			epatch ../patches/preempt-desktop-tune.patch || die "eek!"
		fi
	fi
	rm -r .git
	sed -e "s:EXTRAVERSION =:EXTRAVERSION = -git:" \
		-e "s:SUBLEVEL = 0:SUBLEVEL = 1:" -i Makefile || die "eek!"
}

pkg_postinst() {
	postinst_sources
}
