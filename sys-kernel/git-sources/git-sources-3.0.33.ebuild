# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/sys-kernel/git-sources/git-sources-3.0.34.ebuild,v 1.3 2012/06/14 12:53:49 -tclover Exp $

EAPI=4

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
EGIT_TAG=v${PV/%.0}
EGIT_NOUNPACK="yes"

EGIT_REPO_AUFS="git://aufs.git.sourceforge.net/gitroot/aufs/aufs${KV_MAJOR}-standalone.git"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="aufs bfq bfs fbcondecor ck hz rt"
REQUIRED_USE="ck? ( bfs hz ) hz? ( || ( bfs ck ) ) rt? ( !bfs !ck )"

okv=${KV_MAJOR}.${KV_MINOR}
bfq_uri="http://algo.ing.unimo.it/people/paolo/disk_sched/patches/${okv}.0-v3r4"
bfq_src=${okv}-r4-bfq.patch.bz2
bfs_vrs=406-413
bfs_src=${okv}-bfs-${bfs_vrs}.patch
bfs_uri=http://ck.kolivas.org/patches/bfs/${okv}.0
ck_src=${okv}.0-ck1-broken-out.tar.bz2
ck_uri="http://ck.kolivas.org/patches/${okv}/${okv}/${okv}.0-ck1/"
gen_src=genpatches-$okv-${K_GENPATCHES_VER}.extras.tar.bz2
rt_src=patch-${OKV}-rt54.patch.bz2
rt_uri="https://www.kernel.org/pub/linux/kernel/projects/rt/${okv}/"
RESTRICT="nomirror confcache"
SRC_URI="fbcondecor? ( http://dev.gentoo.org/~mpagano/genpatches/tarballs/${gen_src} )
	bfs? ( ${bfs_uri}/${bfs_src} ) ck? ( ${ck_uri}/${ck_src} ) hz? ( ${ck_uri}/${ck_src} )
	rt? ( ${rt_uri}/${rt_src} )
"
unset okv bfq_uri bfs_uri bfs_vrs ck_uri rt_uri

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its (unstable and)
experimental nature. If you have any issues, try disabling a few USE flags
that you may suspect being the source of your issues because this ebuild is
based on the latest mainline (stable) tree."

src_unpack() {
	git-2_src_unpack
	if use aufs; then
		EGIT_BRANCH=aufs${KV_MAJOR}.${KV_MINOR}
		unset EGIT_COMMIT
		unset EGIT_TAG
		export EGIT_NONBARE=yes
		export EGIT_REPO_URI=${EGIT_REPO_AUFS}
		export EGIT_SOURCEDIR="${WORKDIR}"/aufs${KV_MAJOR}-standalone
		export EGIT_PROJECT=aufs${KV_MAJOR}-standalone
		git-2_src_unpack
	fi
	if use bfs || use hz || use ck; then
		unpack ${ck_src} || die
	fi
}

src_prepare() {
	if use aufs; then
		pushd ../aufs${KV_MAJOR}-standalone && epatch \
			"${FILESDIR}"/aufs-${KV_MAJOR}.${KV_MINOR}.6-loopback_fix.patch && popd
		for file in Documentation fs include/linux/aufs_type.h; do
			cp -pPR "${WORKDIR}"/aufs${KV_MAJOR}-standalone/$file . || die
		done
		mv aufs_type.h include/linux/ || die
		local ap=aufs${KV_MAJOR}-standalone/aufs${KV_MAJOR}
		epatch "${WORKDIR}"/${ap}-{kbuild,base,standalone,loopback,proc_map}.patch
		epatch "${FILESDIR}"/aufs-${KV_MAJOR}.${KV_MINOR}-fix_devcgroup.patch
	fi
	use fbcondecor && epatch "${DISTDIR}"/${gen_src}
	if use bfs || use ck; then
		pushd ../patches && epatch "${FILESDIR}"/bfs-406-413.patch && popd
	fi
	if use ck; then
		sed -i -e "s:ck1-version.patch::g" ../patches/series || die
		for pch in $(< ../patches/series); do
			epatch ../patches/$pch || die
		done
 	else
 		use bfs && epatch ../patches/${bfs_src/bfs-*413/sched-bfs-406}
		if use hz; then
			for pch in $(grep hz ../patches/series); do 
				epatch ../patches/$pch || die
			done
			epatch ../patches/preempt-desktop-tune.patch || die
		fi
	fi
	use bfq && epatch "${FILESDIR}"/${bfq_src}
	use bfs || use ck && epatch "${DISTDIR}"/${bfs_src}
	use rt && epatch "${DISTDIR}"/${rt_src}
	rm -r .git
	sed -e "s:EXTRAVERSION =:EXTRAVERSION = -git:" -i Makefile || die
}

pkg_postinst() {
	postinst_sources
}
