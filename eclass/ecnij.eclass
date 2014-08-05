# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: eclass/ecnij.eclass,v 1.2 2014/07/15 19:33:34 -tclover Exp $

# @ECLASS: ecnij.eclass
# @MAINTAINER: tclover@bar-overlay
# @BLURB: 
# @DESCRIPTION: Exports portage base functions used by ebuilds 
# written for net-print/cnijfilter packages

inherit autotools eutils flag-o-matic multilib-build

IUSE="${IUSE} debug +gtk +nls +servicetools +usb"
KEYWORDS="~x86 ~amd64"

REQUIRED_USE="${REQUIRED_USE} servicetools? ( gtk ) nls? ( gtk )"

has net ${IUSE} && REQUIRED_USE+=" servicetools? ( net )"

RDEPEND="${RDEPEND}
	app-text/ghostscript-gpl[${MULTILIB_USEDEP}]
	dev-libs/glib[${MULTILIB_USEDEP}]
	dev-libs/popt[${MULTILIB_USEDEP}]
	servicetools? ( 
		gnome-base/libglade[${MULTILIB_USEDEP}]
		dev-libs/libxml2[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}] )"

if [[ ${PV:0:1} -eq 3 ]] && [[ ${PV:2:2} -ge 40 ]]; then
	ECNIJ_PVN=true
	RDEPEND="${RDEPEND}
		media-libs/tiff[${MULTILIB_USEDEP}]
		media-libs/libpng[${MULTILIB_USEDEP}]"
else 
#	ECNIJ_PVN=false
	use amd64 && multilib_toolchain_setup "x86"
	RDEPEND="${RDEPEND}
		sys-libs/lib-compat[${MULTILIB_USEDEP}]"
fi

[[ x${ECNIJ_SRC_BUILD} == xdrivers ]] &&
RDEPEND="${RDEPEND}
	net-print/cnijfilter[${MULTILIB_USEDEP}]"

DEDEPEND="${DEPEND}
	nls? ( >=sys-devel/gettext-0.10.38[${MULTILIB_USEDEP}] )"

case "${EAPI:-4}" in
	0|1) EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install pkg_postinst;;
	2|3|4|5) EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install pkg_postinst;;
	*) die "EAPI=\"${EAPI}\" is not supported";;
esac

# @ECLASS-VARIABLE: PRINTER_USE
# @DESCRIPTION: An array with printers USE flags

# @ECLASS-VARIABLE: PRINTER_ID
# @DESCRIPTION: An array with printers id

# @ECLASS-VARIABLE: ELTCONF
# @DESCRIPTION: Extra options passed to elibtoolize
ELTCONF=${ELTCONF:="--force --copy --automake"}

# @ECLASS-VARIABLE: EGTCONF
# @DESCRIPTION: Extra options passed to glib-gettextize
EGTCONF=${EGTCONF:="--force --copy"}

# @FUNCTION: ecnij_pkg_setup
# @DESCRIPTION:
ecnij_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	CNIJFILTER_SRC="libs pstocanonij"
	PRINTER_SRC="cnijfilter"
	use usb && CNIJFILTER_SRC+=" backend"
	if use gtk; then
		CNIJFILTER_SRC+=" cngpijmon"
		PRINTER_SRC+=" lgmon"
		use_if_iuse net && CNIJFILTER_SRC+=" cngpijmon/cnijnpr"
	fi
	use servicetools && CNIJFILTER_SRC+=" cngpij cngpijmnt maintenance"
	use_if_iuse net && CNIJFILTER_SRC+=" backendnet"
}

# @FUNCTION: ecnij_src_unpack
# @DESCRIPTION:
ecnij_src_unpack() {
	debug-print-function ${FUNCNAME} "${@}"

	default
	cd "${S}"
}

# @FUNCTION: dir_src_prepare
# @DESCRIPTION:
dir_src_prepare() {
	local e
	has ${EAPI:-0} 0 1 && e="nonfatal elibtoolize" ||
		e="autotools_run_tool libtoolize"
	[ -d configures ] && mv -f configures/configure.in.new configure.in
	use nls && [ -d po ] && echo "no" | glib-gettextize ${EGTCONF}
	${e} ${ELTCONF}
	eaclocal
	eautoheader
	eautomake --gnu
	eautoreconf
}

# @FUNCTION: ecnij_src_prepare
# @DESCRIPTION: prepare environment and run elibtoolize.
ecnij_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${PATCHES} ]] && epatch "${PATCHES[@]}"

	epatch_user

	[[ x${ECNIJ_SRC_BUILD} == xcore ]] &&
	for dir in ${CNIJFILTER_SRC}; do
		pushd ${dir} || die
		dir_src_prepare
		popd
	done

	local p pr prid
	[[ x${ECNIJ_SRC_BUILD} == xdrivers ]] &&
	for (( p=0; p<${#PRINTER_ID[@]}; p++ )); do
		pr=${PRINTER_USE[$p]} prid=${PRINTER_ID[$p]}
		if use ${pr}; then
			mkdir ${pr} || die
			for dir in ${prid} ${PRINTER_SRC}; do
				cp -a ${dir} ${pr} || die
			done
			pushd ${pr} || die
			[[ -d ../com ]] && ln -s {../,}com || die
			printer_src_prepare
			popd
		fi
	done
}

# @FUNCTION: ecnij_src_configure
# @DESCRIPTION:
ecnij_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ x${ECNIJ_SRC_BUILD} == xcore ]] &&
	for dir in ${CNIJFILTER_SRC}; do
		pushd ${dir} || die
		econf --prefix="${EPREFIX}"/usr "${myeconfargs[@]}"
		popd
	done

	mv {,_}lgmon || die
	local p pr prid
	[[ x${ECNIJ_SRC_BUILD} == xdrivers ]] &&
	for (( p=0; p<${#PRINTER_ID[@]}; p++ )); do
		pr=${PRINTER_USE[$p]} prid=${PRINTER_ID[$p]}
		if use ${pr}; then
			ln -sf ${pr}/lgmon lgmon
			pushd ${pr} || die
			printer_src_configure
			popd
		fi
	done
}

# @FUNCTION: ecnij_src_compile
# @DESCRIPTION:
ecnij_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	local p pr prid
	[[ x${ECNIJ_SRC_BUILD} == xdrivers ]] &&
	for (( p=0; p<${#PRINTER_ID[@]}; p++ )); do
		pr=${PRINTER_USE[$p]} prid=${PRINTER_ID[$p]}
		if use ${pr}; then
			pushd ${pr} || die
			printer_src_compile
			popd
		fi
	done

	[[ x${ECNIJ_SRC_BUILD} == xcore ]] &&
	for dir in ${CNIJFILTER_SRC}; do
		pushd ${dir} || die
		emake || die
		popd
	done
}

# @FUNCTION: ecnij_src_install
# @DESCRIPTION:
ecnij_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	local abi_libdir=/usr/$(get_libdir) p pr prid
	local abi_lib=$(grep -q 64 && echo 64 || echo 32)
	mkdir -p "${ED}"${abi_libdir}/cnijlib

	[[ ${ECNIJ_PVN} ]] || abi_lib=

	[[ x${ECNIJ_SRC_BUILD} == xcore ]] &&
	for dir in ${CNIJFILTER_SRC}; do
		pushd ${dir} || die
		emake DESTDIR="${D}" install || die
		popd
	done

	[[ x${ECNIJ_SRC_BUILD} == xdrivers ]] &&
	for (( p=0; p<${#PRINTER_ID[@]}; p++ )); do
		pr=${PRINTER_USE[$p]} prid=${PRINTER_ID[$p]}
		if use ${pr}; then
			pushd ${pr} || die
			printer_src_install
			popd

			dolib.so ${prid}/libs_bin${abi_lib}/*.so*
			dosym ${abi_libdir}/{cnij,bj}lib
			exeinto ${abi_libdir}/cnijlib
			doexe ${prid}/database/*
			insinto /usr/share/cups/model
			doins ppd/canon${pr}.ppd
		fi
	done

	[[ x${ECNIJ_SRC_BUILD} == xdrivers ]] &&
	if use_if_iuse net; then
		dolib.so com/libs_bin${abi_lib}/*.so*
		EXEOPTIONS="-m555 -glp -olp"
		exeinto ${abi_libdir}/cnijlib
		doexe com/ini/cnnet.ini
	fi
}
# @FUNCTION: ecnij_{prepare,configure,compile,install}_pr
# @DESCRIPTION: internal functions
printer_src_prepare() {
	for dir in ${PRINTER_SRC}; do
		pushd ${dir} || die
		dir_src_prepare
		popd
	done
}
printer_src_configure() {
	for dir in ${PRINTER_SRC}; do
		pushd ${dir} || die
		econf --program-suffix=${pr} --enable-progpath="${EPREFIX}"/usr
		popd
	done
}
printer_src_compile() {
	for dir in ${PRINTER_SRC}; do
		pushd ${dir} || die
		emake ${myconf} || die "${dir}: emake failed"
		popd
	done
}
printer_src_install() {
	for dir in ${PRINTER_SRC}; do
		pushd ${dir} || die
		emake DESTDIR="${D}" install || die "${dir}: emake install failed"
		popd
	done
}

# @FUNCTION: ecnij_pkg_postinst
# @DESCRIPTION: output some usefull info
ecnij_pkg_postinst() {
	debug-print-function ${FUNCNAME} "${@}"

	elog "To install a printer:"
	elog " * First, restart CUPS: /etc/init.d/cupsd restart"
	elog " * Go to http://127.0.0.1:631/ with your favorite browser"
	elog "   and then go to Printers/Add Printer"
	elog "You can consult the following for any issue/bug:"
	elog "https://forums.gentoo.org/viewtopic-p-3217721.html"
	elog "https://bugs.gentoo.org/show_bug.cgi?id=258244"
}
