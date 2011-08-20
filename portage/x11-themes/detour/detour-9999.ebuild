# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/enterminus/enterminus-9999.ebuild,v 1.1 2005/09/07 03:52:46 vapier Exp $

if use elm; then
	ESVN_SUB_PROJECT="THEMES"
	inherit enlightenment
else
	inherit subversion
fi

DESCRIPTION="DTR theme - create a consistent GUI for DR17 - \
e17 e17--init elicit etk ewl entrance exquisite"

DEPEND="x11-wm/enlightenment"
ESVN_URI="http://detour.googlecode.com/svn/branches/"
IUSE="e17 e17-init elicit elm entrance etk exquisite ewl"
SLOT="0"

src_unpack() {
	if use elm; then
		export ESVN_URI_APPEND="detour-elm"
		subversion_src_unpack
	fi
#	export ESVN_PROJECT=detour
#	unset ESVN_SUB_PROJECT
	for branch in e17 e17-init elicit entrance etk exquisite ewl
	do
		export ESVN_REPO_URI=$ESV_URI/$branch
#		export ESVN_URI_APPEND=$branch
		subversion_src_unpack
	done
}

src_compile() {
	emake || die "eek!"
}

src_install() {
	emake HOME="${D}"/usr install || die "eek!"
}
