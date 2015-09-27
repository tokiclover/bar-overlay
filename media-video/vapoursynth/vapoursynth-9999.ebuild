# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-video/vapursynth/vapursynth-9999.ebuild,v 1.1 2015/09/24 Exp $

EAPI=5
PYTHON_COMPAT=( python3_{3,4} )
PYTHON_REQ_USE='threads(+)'

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/vapoursynth/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~ppc ~x86"
		SRC_URI="https://github.com/vapoursynth/${PN}/archive/R${PV}.tar.gz -> ${P}.tar.gz"
		VCS_ECLASS=vcs-snapshot
		;;
esac
inherit eutils distutils-r1 autotools-utils ${VCS_ECLASS}

DESCRIPTION="Video processing framework with simplicity in mind"
HOMEPAGE="http://www.vapoursynth.com/ https://github.com/vapoursynth/vapoursynth"

LICENSE="LGPL-2.1 OFL-1.1"
SLOT="0/${PV}"
IUSE="debug +python static static-libs +vapoursynth-pipe +vapoursynth-script"
REQUIRED_USE="vapoursynth-pipe? ( vapoursynth-script )
	python? ( ${PYTHON_REQUIRED_USE} )"

DEFAULT_PLUGINS=( eedi3 morpho removegrain inverse:vinverse ivtc:vivtc )
for i in ass:assvapour image:imwri ocr "${DEFAULT_PLUGINS[@]}"; do
	if has "${i%:*}" ${VAPOURSYNTH_PLUGINS} ||
		has "${i}" "${DEFAULT_PLUGINS[@]}"; then
		IUSE+=" +vapoursynth_plugins_${i%:*}"
	else
		IUSE+="  vapoursynth_plugins_${i%:*}"
	fi
done
unset i

RDEPEND="|| ( >=media-video/libav-11:=
		>=media-video/ffmpeg-2.4.0:= )
	python? ( dev-python/cython[${PYTHON_USEDEP}]
		${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	debug? ( sys-devel/gdb )
	vapoursynth-script? ( ${PYTHON_DEPS} )
	vapoursynth_plugins_ass? ( media-libs/libass )
	vapoursynth_plugins_image? ( media-gfx/imagemagick[cxx,hdri(-)] )
	dev-lang/yasm
	virtual/pkgconfig"

AUTOTOOLS_AUTORECONF=1
DOCS=( ChangeLog )

src_configure()
{
	local -a myeconfargs=(
		${EXTRA_VAPURSYNTH_CONF}
		$(use_enable debug)
		$(use_enable python python-module)
		$(usex python --with-cython="${EPREFIX}/usr/lib/python-exec/${PYTHON_TARGETS/_/.}/cython" "")
		$(use_enable static)
		$(use_enable !static-libs shared)
		$(use_enable vapoursynth-pipe vspipe)
		$(use_enable vapoursynth-script vsscript)
		--enable-core
		--enable-guard-pattern
	)
	local i
	for i in ass:assvapour image:imwri ocr "${DEFAULT_PLUGINS[@]}"; do
		myeconfargs+=( $(use_enable vapoursynth_plugins_${i%:*} ${i#*:}) )
	done
	autotools-utils_src_configure
}
src_compile()
{
	autotools-utils_src_compile
	autotools-utils_src_compile -C "${S}/doc" man
	use python && LDFLAGS="${LDFLAGS} -L${ED}/usr/$(get_libdir)" \
		CFLAGS="${CFLAGS} $(usex static-libs '' '-fPIC')" \
		distutils-r1_src_compile
}
src_install()
{
	autotools-utils_src_install
	use python && distutils-r1_src_install
	doman doc/_build/man/*
}
