# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/enterminus/enterminus-9999.ebuild,v 1.1 2005/09/07 03:52:46 vapier Exp $

inherit subversion

DESCRIPTION="DTR theme - create a consistent GUI for DR17 - \
e17 e17--init elicit etk ewl entrance exquisite"

DEPEND="x11-wm/enlightenment"
ESVN_REPO_URI="https://detour.googlecode.com/svn/branches/"
IUSE="elicit entrance etk ewl"
SLOT="0"

S=${WORKDIR}/branches

src_compile() {
	emake || die "eek!"
}

src_compile() {
	for branch in e17{,-init}; do
		cd $branch
		emake build || die "eek!"
		cd ..
	done
	for branch in elicit entrance etk ewl; do
		if use $branch; then
			cd $branch
			emake build || die "eek!"
			cd ..
		fi
	done
}

src_install() {
	for branch in e17{,-init}; do
		cd $branch
		emake PATH_INSTALL="${D}"/usr install || die "eek!"
		cd ..
	done
	for branch in elicit entrance etk ewl; do
		if use $branch; then
			cd $branch
			emake PATH_INSTALL="${D}"/usr install || die "eek!"
			cd ..
		fi
	done
}
