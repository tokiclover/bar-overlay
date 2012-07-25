# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-sound/oss/oss-4.2.9999.ebuild,v 1.2 2012/07/25 22:34:08 -tclover Exp $

EAPI=2

inherit mercurial flag-o-matic

filter-ldflags "-Wl,-O1"

EHG_REPO_URI="http://opensound.hg.sourceforge.net:8000/hgroot/opensound/opensound"

DESCRIPTION="OSSv4 portable, mixing-capable, high quality sound system for Unix"
HOMEPAGE="http://developer.opensound.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+midi"

DEPEND="sys-apps/gawk
	x11-libs/gtk+:2
	>=sys-kernel/linux-headers-2.6.11
	!media-sound/oss-devel"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	mercurial_src_unpack
	mkdir build

	cp "${FILESDIR}"/oss "${S}"/setup/Linux/oss/etc/S89oss
}

src_configure() {
	local conf="--enable-timings \
		$(use midi && echo '--config-midi=YES' || echo '--config-midi=NO')"
	cd ../build
	"${S}"/configure ${conf} || die "configure failed"
	sed -i -e 's/-D_KERNEL//' -i Makefile
}

src_compile() {
	cd ../build
	emake build || die "emake build failed"
}

src_install() {
	newinitd "${FILESDIR}"/oss oss
	cd ../build
	cp -R prototype/* "${D}"
}

pkg_postinst() {
	elog "To use ${P} for the first time you must run"
	elog "# /etc/init.d/oss start "
	elog ""
	elog "If you are upgrading, run"
	elog "# /etc/init.d/oss restart "
	elog ""
	elog "Enjoy OSSv4!"
}
