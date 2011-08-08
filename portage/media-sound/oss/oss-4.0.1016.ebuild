# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

# For the news, see the commit messages.

DESCRIPTION="Open Sound System - portable, mixing-capable, high quality sound system for Unix."
HOMEPAGE="http://developer.opensound.com/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flash"

DEPEND="sys-apps/gawk 
	>=x11-libs/gtk+-2 
	>=sys-kernel/linux-headers-2.6.11
	!media-sound/oss-devel"

RDEPEND="${DEPEND}
	flash? ( net-www/libflashsupport )"

RESTRICT="mirror"

MY_PV=$(get_version_component_range 1-2)
MY_BUILD=$(get_version_component_range 3)
MY_P="oss-v${MY_PV}-build${MY_BUILD}-src-gpl"

SRC_URI="http://www.4front-tech.com/developer/sources/stable/gpl/${MY_P}.tar.bz2"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack "${A}"
	mkdir "${WORKDIR}/build"
	cd "${S}"

	einfo "Applying patches..."

	epatch "${FILESDIR}/${P}-soundon_no_libsalsa.patch" \
			|| die "soundon_no_libsalsa patch failed"
	
	if [ "${ARCH}" == "x86" ]
	then
		epatch "${FILESDIR}/${P}-srcconf_x86.patch" \
			|| die "srcconf_x86 patch failed"
	fi

	einfo "Replacing init script with gentoo friendly one..."

	cp "${FILESDIR}/oss" "${S}/setup/Linux/oss/etc/S89oss"
}

src_compile() {
	
	# Configure has to be run from build dir with full path.
	cd "${WORKDIR}/build"
	"${S}"/configure || die  "configure failed"

        einfo "Stripping compiler flags..."
        sed -i -e 's/-D_KERNEL//' \
		"${WORKDIR}/build/Makefile"

	# Remove libsalsa as it's outdated
	sed -i -e 's/^SUBDIRS=libOSSlib libsalsa/SUBDIRS=libOSSlib/g' \
		"${WORKDIR}/build/lib/Makefile"
	sed -i -e 's/^SUBDIRS=libOSSlib libsalsa/SUBDIRS=libOSSlib/g' \
		"${WORKDIR}/build/noregparm/lib/Makefile"

	emake build || die "emake build failed"
}
	

src_install() {
	newinitd "${FILESDIR}/oss" oss
	cd "${WORKDIR}/build"
	cp -R prototype/* "${D}" 
}

pkg_postinst() {
	elog "PLEASE NOTE:"
	elog ""
	elog "In order to use OSSv4.0 you must run"
	elog "# /etc/init.d/oss start "
	elog ""
	elog "If you are upgrading from a previous build of OSSv4.0 you must run"
	elog "# /etc/init.d/oss restart "
	elog ""
	elog "Enjoy OSSv4.0 !"
}
