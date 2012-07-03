# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-gfx/freecad/freecad-9999.ebuild,v 1.2 2012/07/04 00:20:37 -tclover Exp $

EAPI=4
PYTHON_DEPEND=2

inherit base multilib fortran-2 flag-o-matic python cmake-utils git-2

PATCHLEVEL="0.12.5284"
MY_P="freecad-${PATCHLEVEL}"
MY_PD="FreeCAD-${PV}"
MY_PDIR="/usr/share/${P}"

DESCRIPTION="QT based Computer Aided Design application"
HOMEPAGE="http://sourceforge.net/apps/mediawiki/free-cad/"
EGIT_REPO_URI="git://free-cad.git.sourceforge.net/gitroot/free-cad/free-cad"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-cpp/eigen:3
	dev-games/ode
	dev-libs/boost
	dev-libs/libf2c
	dev-libs/xerces-c
	dev-python/pivy
	dev-python/PyQt4[svg]
	media-libs/coin
	media-libs/SoQt
	>=sci-libs/opencascade-6.3-r3
	sci-libs/gts
	sys-libs/zlib
	virtual/fortran
	x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	x11-libs/qt-svg:4
	x11-libs/qt-webkit:4
	x11-libs/qt-xmlpatterns:4
"
DEPEND="${RDEPEND}
	>=dev-lang/swig-2.0.4-r1
"

RESTRICT="bindist mirror"
# http://bugs.gentoo.org/show_bug.cgi?id=352435
# http://www.gentoo.org/foundation/en/minutes/2011/20110220_trustees.meeting_log.txt

S="${WORKDIR}/${MY_PD}"

PATCHES=(
	"${FILESDIR}/${MY_P}-gcc46.patch"
	"${FILESDIR}/${MY_P}-glu.patch"
	"${FILESDIR}/${MY_P}-nodir.patch"
)

pkg_setup() {
	fortran-2_pkg_setup
	python_set_active_version 2
}

src_prepare() {
	base_src_prepare
	sed -i -e '/BUILD_DEBIAN/,/BUILD_DEBIAN/d' src/3rdParty/CMakeLists.txt || die
	sed -i -e 's/qPixmapFromMimeSource//g' src/Mod/Arch/Resources/ui/archprefs-base.ui || die
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
