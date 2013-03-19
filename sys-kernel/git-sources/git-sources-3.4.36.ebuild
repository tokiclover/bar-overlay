# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar/sys-kernel/git-sources/git-sources-3.4.34.ebuild,v 1.5 2013/03/19 21:20:50 -tclover Exp $

EAPI=5

UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="yes"
K_DEBLOB_AVAILABLE=0
K_WANT_GENPATCHES="extras"
K_GENPATCHES_VER="1"
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
EGIT_COMMIT=v${PV/%.0}
EGIT_NOUNPACK="yes"

EGIT_REPO_AUFS="git://aufs.git.sourceforge.net/gitroot/aufs/aufs${KV_MAJOR}-standalone.git"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="aufs bfq bfs bld fbcondecor ck hz uksm"
REQUIRED_USE="ck? ( bfs hz ) hz? ( || ( bfs ck ) )"

okv=${KV_MAJOR}.${KV_MINOR}
bfq_uri="http://algo.ing.unimo.it/people/paolo/disk_sched/patches/${okv}.0-v4"
bfq_src=${okv}-bfq-v6.patch.bz2
bfs_src=${okv}-sched-bfs-424.patch
bfs_uri=http://ck.kolivas.org/patches/bfs/$okv/
bld_uri=https://bld.googlecode.com/files
bld_src=bld-${KV_MAJOR}.5.0.tar.bz2
ck_src=${okv}-ck3-broken-out.tar.bz2
ck_uri="http://ck.kolivas.org/patches/${okv:0:1}.0/${okv}/${okv}-ck3/"
gen_src=genpatches-$okv-${K_GENPATCHES_VER}.extras.tar.bz2
uksm_uri=http://kerneldedup.org/download/uksm/0.1.2.2
uksm_src=uksm-0.1.2.2-for-v${okv}.ge.36.patch
RESTRICT="nomirror confcache"
SRC_URI="fbcondecor? ( http://dev.gentoo.org/~mpagano/genpatches/tarballs/${gen_src} )
	bfs? ( ${ck_uri}/${ck_src} ) ck? ( ${ck_uri}/${ck_src} ) hz? ( ${ck_uri}/${ck_src} )
	bld? ( ${bld_uri}/${bld_src} ) uksm? ( ${uksm_uri}/${uksm_src} )
"
unset bfq_uri bfs_uri bfs_vrs bld_uri ck_uri uksm_uri

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its (unstable and)
experimental nature. If you have any issues, try disabling a few USE flags
that you may suspect being the source of your issues because this ebuild is
based on the latest mainline (stable) tree."

src_unpack() {
	if use bfs || use hz || use ck; then
		unpack ${ck_src}
	fi
	use bld && unpack ${bld_src}
	git-2_src_unpack
	if use aufs; then
		EGIT_BRANCH=aufs${KV_MAJOR}.${KV_MINOR}
		unset EGIT_COMMIT
		export EGIT_NONBARE=yes
		export EGIT_REPO_URI=${EGIT_REPO_AUFS}
		export EGIT_SOURCEDIR="${WORKDIR}"/aufs${KV_MAJOR}-standalone
		export EGIT_PROJECT=aufs${KV_MAJOR}-standalone.git
		git-2_src_unpack
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
		pushd "${WORKDIR}" && epatch "${FILESDIR}"/${bfs_src}.patch && popd
		sed -e "s,linux-${okv}-ck[0-9]/,,g" -i "${WORKDIR}"/patches/${bfs_src} || die
	fi
	if use ck; then
		sed -i -e "s:ck1-version.patch::g" "${WORKDIR}"/patches/series || die
		for pch in $(< "${WORKDIR}"/patches/series); do
			epatch "${WORKDIR}"/patches/$pch || die
		done
 	else
 		use bfs && epatch "${WORKDIR}"/patches/${bfs_src}
		if use hz; then
			for pch in $(grep hz "${WORKDIR}"/patches/series); do 
				epatch "${WORKDIR}"/patches/$pch
			done
			epatch "${WORKDIR}"/patches/preempt-desktop-tune.patch
		fi
	fi
	if use bfs || use ck; then
		epatch "${FILESDIR}"/3.4-sched-bfs-424-no_hz.patch
	fi
	if use bld; then
		pushd "${WORKDIR}" &&
		epatch "${FILESDIR}"/3.4-bld-3.5.patch && popd &&
		epatch "${WORKDIR}"/bld-3.5.0/BLD-3.5.patch
	fi
	use bfq && epatch "${FILESDIR}"/${bfq_src}
	use uksm && epatch "${DISTDIR}"/${uksm_src}
	rm -fr .git* b
	sed -e "s:EXTRAVERSION =:EXTRAVERSION = -git:" -i Makefile || die
}

pkg_postinst() {
	postinst_sources
}
