# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
[[ "${PV}" = "9999" ]] && inherit subversion
inherit multilib-minimal

DESCRIPTION="ASIO driver for WINE"
HOMEPAGE="http://sourceforge.net/projects/wineasio"
if [ "${PV}" = "9999" ]; then
	ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk/${PN}"
	KEYWORDS=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi
RESTRICT="mirror"
LICENSE="GPL-2"
IUSE=""
SLOT="0"

DEPEND="media-libs/asio-sdk"
RDEPEND=">=app-emulation/wine-0.9.35[${MULTILIB_USEDEP}]
	>=media-sound/jack-audio-connection-kit-1.9.9.5[${MULTILIB_USEDEP}]"

S="${WORKDIR}/${PN}"

src_prepare() {
	cp /opt/asiosdk2.3/ASIOSDK2.3/common/asio.h .
	multilib_copy_sources
}

multilib_src_configure() {
	if has_multilib_profile && [[ ${ABI} == "amd64" ]] ; then
		mv Makefile64 Makefile
		./prepare_64bit_asio
	fi

	default
}

multilib_src_install() {
	exeinto /usr/$(get_libdir)/wine
	doexe *.so
}

pkg_postinst() {
	echo
	elog "Finally the dll must be registered in the wineprefix."
	elog "For both 32 and 64 bit wine do:"
	elog "# regsvr32 wineasio.dll"
	elog
	elog "On a 64 bit system with wine supporting both 32 and 64 applications, regsrv32"
	elog "will register the 32 bit driver in a 64 bit prefix, use the following command"
	elog "to register the 64 bit driver in a 64 bit wineprefix:"
	elog 
	elog "# wine64 regsvr32 wineaiso.dll"
	elog
	elog "regsvr32 registers the ASIO COM object in the default prefix "~/.wine"."
	elog "To use another prefix specify it explicitly, like:"
	elog "# env WINEPREFIX=~/asioapp regsvr32 wineasio.dll"
	echo
}
