# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/x11-plugins/elsa/eupnp-9999.ebuild,v 1.1 2011/11/05 -tclover Exp $

EAPI=4

ESVN_SUB_PROJECT="PROTO"
inherit enlightenment

DESCRIPTION="PAM compatible session manager, epigone of entrance"

IUSE="doc coverage examples test tools static-libs"
REQUIRED_USE="coverage? ( test )"

DEPEND=">=dev-libs/ecore-1.0[curl]
	>=dev-libs/eina-1.0
	dev-libs/libxml2
"
RDEPEND=""

src_configure() {
	export MY_ECONF="
		$(use_enable coverage coverage)
		$(use_enable doc doc)
		$(use_enable examples examples)
		$(use_enable static-libs static)
		$(use_enable test tests)
		$(use_enable tools tools)
	"
	enlightenment_src_configure
}
