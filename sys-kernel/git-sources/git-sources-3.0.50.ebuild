# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/sys-kernel/git-sources/git-sources-3.0.38.ebuild,v 1.4 2012/10/23 18:37:20 -tclover Exp $

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
EGIT_COMMIT=v${PV/%.0}
EGIT_NOUNPACK="yes"

EGIT_REPO_AUFS="git://aufs.git.sourceforge.net/gitroot/aufs/aufs${KV_MAJOR}-standalone.git"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="aufs bfq bfs fbcondecor ck hz uksm"
REQUIRED_USE="ck? ( bfs hz ) hz? ( || ( bfs ck ) )"

okv=${KV_MAJOR}.${KV_MINOR}
bfq_uri="http://algo.ing.unimo.it/people/paolo/disk_sched/patches/${okv}.0-v4"
bfq_src=${okv}-bfq-v5.patch.bz2
bfs_src=${okv}-sched-bfs-406-13.patch
bfs_uri=http://ck.kolivas.org/patches/bfs/${okv}.0
ck_src=${okv}.0-ck1-broken-out.tar.bz2
ck_uri="http://ck.kolivas.org/patches/${okv}/${okv}/${okv}.0-ck1/"
gen_src=genpatches-$okv-${K_GENPATCHES_VER}.extras.tar.bz2
uksm_uri=http://kerneldedup.org/download/uksm/0.1.2.1
uksm_src=uksm-0.1.2.1-for-v${okv}.ge.46.patch
RESTRICT="nomirror confcache"
SRC_URI="fbcondecor? ( http://dev.gentoo.org/~mpagano/genpatches/tarballs/${gen_src} )
	bfs? ( ${ck_uri}/${ck_src} ) ck? ( ${ck_uri}/${ck_src} ) hz? ( ${ck_uri}/${ck_src} )
	uksm? ( ${uksm_uri}/${uksm_src} )
"
unset bfq_uri bfs_uri ck_uri uksm_uri

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its (unstable and)
experimental nature. If you have any issues, try disabling a few USE flags
that you may suspect being the source of your issues because this ebuild is
based on the latest mainline (stable) tree."

src_unpack() {
	if use bfs || use hz || use ck; then
		unpack ${ck_src}
	fi
	git-2_src_unpack
	if use aufs; then
		EGIT_BRANCH=aufs${KV_MAJOR}.${KV_MINOR}
		unset EGIT_COMMIT
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
		pushd "${WORKDIR}"/aufs${KV_MAJOR}-standalone && epatch \
			"${FILESDIR}"/${okv}-aufs-loopback_fix.patch && popd
		for file in Documentation fs include/linux/aufs_type.h; do
			cp -pPR "${WORKDIR}"/aufs${KV_MAJOR}-standalone/$file . || die
		done
		mv aufs_type.h include/linux/ || die
		local ap=aufs${KV_MAJOR}-standalone/aufs${KV_MAJOR}
		epatch "${WORKDIR}"/${ap}-{kbuild,base,standalone,loopback,proc_map}.patch
		epatch "${FILESDIR}"/${okv}-aufs-fix_devcgroup.patch
	fi
	use fbcondecor && epatch "${DISTDIR}"/${gen_src}
	if use bfs || use ck; then
		pushd "${WORKDIR}" && epatch "${FILESDIR}"/${bfs_src/13/16}.patch && popd
		sed -e "s,${okv}-ck[0-9],${CKV},g" -i "${WORKDIR}"/patches/${bfs_src/-13/} || die
	fi
	if use ck; then
		sed -i -e "s:ck1-version.patch::g" "${WORKDIR}"/patches/series || die
		for pch in $(< "${WORKDIR}"/patches/series); do
			epatch "${WORKDIR}"/patches/$pch
		done
 	else
 		use bfs && epatch "${WORKDIR}"/patches/${bfs_src/bfs-*413/sched-bfs-406}
		if use hz; then
			for pch in $(grep hz "${WORKDIR}"/patches/series); do 
				epatch "${WORKDIR}"/patches/$pch
			done
			epatch "${WORKDIR}"/patches/preempt-desktop-tune.patch
		fi
	fi
	use bfq && epatch "${FILESDIR}"/${bfq_src}
	use bfs || use ck && epatch "${DISTDIR}"/${bfs_src}
	use uksm && epatch "${DISTDIR}"/${uksm_src}
	rm -r .git
	sed -e "s:EXTRAVERSION =:EXTRAVERSION = -git:" -i Makefile || die
}

pkg_postinst() {
	postinst_sources
}