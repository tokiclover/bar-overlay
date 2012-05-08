# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-gfx/exquisite/exquisite-9999.ebuild,v 1.1 2012/05/08 -tclover Exp $

EAPI=4

inherit enlightenment

DESCRIPTION="tool to create a graphical bootsplash with animation, status feedback, and more"

IUSE="+cache examples +evas directfb +fbcon opengl +nls +X"

DEPEND=">=dev-libs/ecore-1.0[evas,fbcon]
	>=dev-libs/eet-1.4.0[nls]
	>=dev-libs/eina-1.0[nls]
	>=media-libs/edje-1.0[cache,nls]
	>=media-libs/evas-1.0[fbcon,directfb?,opengl?,X]
"

src_install() {
	enlightenment_src_install
	if use examples; then
		sed -e 's:../src/bin/exquisite:\$(which exquisite):g' \
			-e 's:../src/bin/exquisite-write:\$(which exquisite-write):g' \
			-e 's:../data/themes/default.edj:default:g' \
			-i demo/run-demo.sh || die
		install -m 755 demo/run-demo.sh "${D}"/usr/bin/${PN}-demo.sh || die
	fi
}
