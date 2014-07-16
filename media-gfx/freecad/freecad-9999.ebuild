# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-gfx/freecad/freecad-9999.ebuild,v 1.3 2014/07/15 23:23:14 -tclover Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit base multilib fortran-2 flag-o-matic python cmake-utils git-2

PATCHLEVEL="0.12.5284"
MY_P="freecad-${PATCHLEVEL}"
MY_PD="FreeCAD-${PV}"
MY_PDIR="/usr/share/${P}"

DESCRIPTION="QT based Computer Aided Design application"
HOMEPAGE="http://sourceforge.net/projects/mediawiki/free-cad/"
EGIT_REPO_URI="git://git.code.sf.net/p/free-cad/code.git"
EGIT_PROJECT=${PN}.git

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	dev-cpp/eigen:3
	dev-games/ode
	>=dev-libs/boost-1.33.1
	dev-libs/libf2c
	>=dev-libs/xerces-c-2.6.0
	dev-python/pivy
	dev-python/PyQt4[svg]
	>=media-libs/coin-2.4.0
	>=media-libs/SoQt-1.2.0
	>=sci-libs/opencascade-6.3-r3
	sci-libs/gts
	sys-libs/zlib
	virtual/fortran
	>=x11-libs/qt-gui-4.5:4
	>=x11-libs/qt-opengl-4.5:4
	>=x11-libs/qt-svg-4.5:4
	>=x11-libs/qt-webkit-4.5:4
	>=x11-libs/qt-xmlpatterns4.5:4
"
DEPEND="${RDEPEND}
	>=dev-lang/swig-2.0.11
"

RESTRICT="bindist"

S="${WORKDIR}/${MY_PD}"

PATCHES=(
	"${FILESDIR}/${MY_P}-gcc46.patch"
)

pkg_setup() {
	fortran-2_pkg_setup
	python_set_active_version 2
}

src_prepare() {
	base_src_prepare
	sed -e '/BUILD_DEBIAN/,/BUILD_DEBIAN/d' \
	    -i src/3rdParty/CMakeLists.txt || die
	sed -e 's/qPixmapFromMimeSource//g' \
	    -i src/Mod/Arch/Resources/ui/archprefs-base.ui || die
	sed -i -e '/Swig_1_3_/d' src/Base/Interpreter.cpp || die
	sed -i -e '/swigpyrun_1.3./d' src/Base/Makefile.am || die
	append-cxxflags -fpermissive
}

src_configure() {
	local mycmakeargs=(
		-DOCC_INCLUDE_DIR=${CASROOT}/inc
		-DOCC_INCLUDE_PATH=${CASROOT}/inc
		-DOCC_LIBRARY=${CASROOT}/lib/libTKernel.so
		-DOCC_LIBRARY_DIR=${CASROOT}/lib
		-DOCC_LIB_PATH=${CASROOT}/lib
		-DCOIN3D_INCLUDE_DIR=/usr/include/coin
		-DCOIN3D_LIBRARY=/usr/$(get_libdir)/libCoin.so
		-DSOQT_LIBRARY=/usr/$(get_libdir)/libSoQt.so
		-DSOQT_INCLUDE_PATH=/usr/include/coin
		-DCMAKE_INSTALL_PREFIX=${MY_PDIR}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	find "${D}" -name "*.la" -exec rm {} +
	make_wrapper ${PN} ${MY_PDIR}/bin/FreeCAD ${MY_PDIR} ${MY_PDIR}/lib 
	sed -i -e "s|Path=.*|Path=${MY_PDIR}|" -e "s|Icon=.*|Icon=${MY_PDIR}/data/${PN}.xpm|" \
			${desktop:=package/debian/${PN}.desktop}
	domenu ${desktop}
	dodoc README.Linux ChangeLog.txt
}
