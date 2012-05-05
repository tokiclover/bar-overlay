# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/media-sound/oss-4.2.9999,v 1.1 2012/05/05 -tclover Exp $

inherit mercurial flag-o-matic

filter-ldflags "-Wl,-O1"

EHG_REPO_URI="http://opensound.hg.sourceforge.net:8000/hgroot/opensound/opensound"

DESCRIPTION="OSS-${PV%*.9999} live build - portable, mixing-capable, high quality sound system for Unix"
HOMEPAGE="http://developer.opensound.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/gawk
	x11-libs/gtk+:2
	>=sys-kernel/linux-headers-2.6.11
	!media-sound/oss-devel"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	mercurial_src_unpack
	mkdir "${WORKDIR}/build"

	einfo "Replacing init script with gentoo friendly one..."
	cp "${FILESDIR}"/oss "${S}"/setup/Linux/oss/etc/S89oss
}

src_compile() {
	einfo "Running configure..."
	cd "${WORKDIR}"/build
	"${S}"/configure || die "configure failed"

	einfo "Stripping compiler flags..."
	sed -i -e 's/-D_KERNEL//' \
		"${WORKDIR}"/build/Makefile

	emake build || die "emake build failed"
}

src_install() {
	newinitd "${FILESDIR}"/oss oss
	cd "${WORKDIR}"/build
	cp -R prototype/* "${D}"
}

pkg_postinst() {
	elog "To use ${P} for the first time you must run"
	elog "# /etc/init.d/oss start "
	elog ""
	elog "If you are upgrading, run"
	elog "# /etc/init.d/oss restart "
	elog ""
	elog "Enjoy OSSv${PV} !"
}
