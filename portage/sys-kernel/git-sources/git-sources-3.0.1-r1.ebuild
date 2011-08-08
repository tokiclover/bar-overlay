# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/git-sources/git-sources-3.0-r1.ebuild,v 1.1 2011/07/23 13:31:58 mpagano Exp $

EAPI=2
UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="yes"
K_DEBLOB_AVAILABLE=0
ETYPE="sources"
CKV="${PVR/-r[0-9]*/-git}"
# only use this if it's not an _rc/_pre release
[ "${PV/_pre}" == "${PV}" ] && [ "${PV/_rc}" == "${PV}" ] && OKV="${PV}"
inherit kernel-2 git-2
detect_version
detect_arch

DESCRIPTION="The very latest -git version of the Linux kernel"
HOMEPAGE="http://www.kernel.org"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
EGIT_COMMIT="94ed5b4788a7cdbe68bc7cb8516972cbebdc8274"
EGIT_PROJECT=${PN}
EGIT_TAG=v${KV_MAJOR}.${KV_PATCH}
EGIT_NOUNPACK="yes"

EGIT_REPO_AUFS="git://aufs.git.sourceforge.net/gitroot/aufs/aufs2-standalone.git"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="fbcondecor tuxonice"

TOI_FILE="current-tuxonice-for-$(get_version_component_range 1-2).patch.bz2"
TOI_URI="tuxonice? ( http://tuxonice.net/files/${TOI_FILE} )"
SRC_URI="${TOI_URI}
		fbcondecor? ( mirror://genpatches-${OKV}-3.extras.tar.bz2 )
"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its unstable and
experimental nature. If you have any issues, try a matching vanilla-sources
ebuild -- if the problem is not there, please contact the upstream kernel
developers at http://bugzilla.kernel.org and on the linux-kernel mailing list to
report the problem so it can be fixed in time for the next kernel release."

src_unpack() {
	git-2_src_unpack
	if [[ ${KV_MAJOR} -le 3 ]]; then 
			EGIT_BRANCH=aufs2.1
	else 	EGIT_BRANCH=aufs2.1-${KV_PATCH}
	fi
	unset EGIT_COMMIT
	unset EGIT_TAG
	export EGIT_NONBARE=yes
	export EGIT_REPO_URI=${EGIT_REPO_AUFS}
	export EGIT_SOURCEDIR="${WORKDIR}"/aufs2-standalone
	export EGIT_PROJECT=aufs2-standalone
	git-2_src_unpack
}

src_prepare() {
	for i in Documentation fs include/linux/aufs_type.h; do
		cp -pPR "${WORKDIR}"/aufs2-standalone/$i . || die "eek!"
	done
	mv aufs_type.h include/linux/ || die "eek!"
	epatch "${WORKDIR}"/aufs2-standalone/{aufs2-{kbuild,base,standalone},loopback,proc_map}.patch
	use fbcondecor && epatch "${DISTDIR}"/genpatches-${OKV}-3.extras.tar.bz2
	use tuxonice && epatch "${DISTDIR}"/${TOI_FILE}
	rm -r .git
	sed -e "s:EXTRAVERSION =:EXTRAVERSION = -git:" \
		-e "s:SUBLEVEL = 0:SUBLEVEL = 1:" -i Makefile || die "eek!"
}

pkg_postinst() {
	postinst_sources
}
