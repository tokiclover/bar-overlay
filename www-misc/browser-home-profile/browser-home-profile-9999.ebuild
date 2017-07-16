# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: www-misc/browser-home-profile/browser-home-profile-3.0.ebuild,v 1.3 2016/03/22 23:40:17 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )

case "${PV}" in
	(9999*)
	KEYWORDS=""
	VCS_ECLASS=git-2
	EGIT_REPO_URI="git://github.com/tokiclover/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://github.com/tokiclover/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	;;
esac
inherit eutils distutils-r1 perl-app ${VCS_ECLASS}

DESCRIPTION="Web-Browser Home Profile Utility"
HOMEPAGE="https://github.com/tokiclover/browser-home-profile"

LICENSE="BSD-2"
SLOT="0"
IUSE="perl python"
REQUIRED_USE=" python? ( ${PYTHON_REQ_USE} )"

DEPEND="sys-apps/sed
	perl? ( dev-lang/perl )
	python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"

src_prepare()
{
	if use perl; then
		perl-module_src_prepare
	elif use python; then
		distutils-r1_src_prepare
	fi
}

src_configure()
{
	if use perl; then
		perl-module_src_configure
		mv -f makefile _makefile_ || die
	elif use python; then
		distutils-r1_src_configure
	fi
}

src_compile()
{
	if use perl; then
		perl-module_src_compile
	elif use python; then
		distutils-r1_src_compile
	fi
}

src_install()
{
	if use perl; then
		perl-module_src_install
	elif use python; then
		distutils-r1_src_install
	else
		sed '/.*COPYING.*$/d' -i Makefile
		emake PREFIX=/usr DESTDIR="${ED}" install
	fi
}
