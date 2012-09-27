# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/sys-kernel/git-sources/git-sources-3.2.22.ebuild,v 1.4 2012/09/27 13:51:27 -tclover Exp $

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
EGIT_TAG=v${PV/%.0}
EGIT_NOUNPACK="yes"

EGIT_REPO_AUFS="git://aufs.git.sourceforge.net/gitroot/aufs/aufs${KV_MAJOR}-standalone.git"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="aufs bfq bfs fbcondecor ck hz uksm"
REQUIRED_USE="ck? ( bfs hz ) hz? ( || ( bfs ck ) )"

okv=${KV_MAJOR}.${KV_MINOR}
bfq_uri="http://algo.ing.unimo.it/people/paolo/disk_sched/patches/${okv}.0-v4"
bfq_src=bfq-${okv}-v4.patch.bz2
bfs_vrs=416
bfs_src=${okv}-sched-bfs-${bfs_vrs}.patch
bfs_uri=http://ck.kolivas.org/patches/bfs/$okv/
ck_src=${okv}-ck1-broken-out.tar.bz2
ck_uri="http://ck.kolivas.org/patches/${okv:0:1}.0/${okv}/${okv}-ck1/"
gen_src=genpatches-$okv-${K_GENPATCHES_VER}.extras.tar.bz2
uksm_uri=http://kerneldedup.org/download/uksm/0.1.2
uksm_src=uksm-0.1.2-for-v${okv}.ge.24.patch
RESTRICT="nomirror confcache"
SRC_URI="fbcondecor? ( http://dev.gentoo.org/~mpagano/genpatches/tarballs/${gen_src} )
	bfs? ( ${ck_uri}/${ck_src} ) ck? ( ${ck_uri}/${ck_src} ) hz? ( ${ck_uri}/${ck_src} )
	uksm? ( ${uksm_uri}/${uksm_src} )
"
unset okv bfq_uri bfs_uri bfs_vrs ck_uri uksm_uri

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
		export EGIT_PROJECT=aufs${KV_MAJOR}-standalone.git
		git-2_src_unpack
	fi
	if use bfs || use hz || use ck; then
		unpack ${ck_src} || die
	fi
}

src_prepare() {
	if use aufs; then
		for file in Documentation fs include/linux/aufs_type.h; do
			cp -pPR "${WORKDIR}"/aufs${KV_MAJOR}-standalone/$file . || die
		done
		mv aufs_type.h include/linux/ || die
		local ap=aufs${KV_MAJOR}-standalone/aufs${KV_MAJOR}
		epatch "${WORKDIR}"/${ap}-{kbuild,base,standalone,loopback,proc_map}.patch
	fi
	use fbcondecor && epatch "${DISTDIR}"/${gen_src}
	if use bfs || use ck; then
		pushd ../patches && epatch "${FILESDIR}"/3.2-sched-bfs-416.patch.patch && popd
	fi
	if use ck; then
		sed -i -e "s:ck1-version.patch::g" ../patches/series || die
		for pch in $(< ../patches/series); do
			epatch ../patches/$pch || die
		done
 	else
 		use bfs && epatch ../patches/${bfs_src}
		if use hz; then
			for pch in $(grep hz ../patches/series); do 
				epatch ../patches/$pch || die
			done
			epatch ../patches/preempt-desktop-tune.patch || die
		fi
	fi
	use bfq && epatch "${FILESDIR}"/${bfq_src}
	use uksm && epatch "${DISTDIR}"/${uksm_src}
	rm -r .git
	sed -e "s:EXTRAVERSION =:EXTRAVERSION = -git:" -i Makefile || die
}

pkg_postinst() {
	postinst_sources
}
