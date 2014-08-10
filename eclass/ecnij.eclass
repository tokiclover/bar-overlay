# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: eclass/ecnij.eclass,v 3.2 2014/08/08 19:33:34 -tclover Exp $

# @ECLASS: ecnij.eclass
# @MAINTAINER: tclover@bar-overlay
# @BLURB: 
# @DESCRIPTION: Exports portage base functions used by ebuilds 
# written for net-print/cnijfilter packages

inherit autotools eutils flag-o-matic multilib-build versionator

IUSE="${IUSE} debug +gtk servicetools +usb"
KEYWORDS="~x86 ~amd64"

REQUIRED_USE="${REQUIRED_USE} servicetools? ( gtk )"

has net ${IUSE} && REQUIRED_USE+=" servicetools? ( net )"

RDEPEND="${RDEPEND}
	app-text/ghostscript-gpl
	dev-libs/glib[${MULTILIB_USEDEP}]
	dev-libs/popt[${MULTILIB_USEDEP}]
	servicetools? ( 
		gnome-base/libglade[${MULTILIB_USEDEP}]
		dev-libs/libxml2[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}] )"

version_is_at_least 3.40 ${PV} && PRINTER_MULTILIB=true
version_is_at_least 3.70 ${PV} && PRINTER_DOC=true

RDEPEND="${RDEPEND}
	media-libs/tiff[${MULTILIB_USEDEP}]
	media-libs/libpng[${MULTILIB_USEDEP}]"

[[ ${PRINTER_DOC} ]] && IUSE+=" +doc"

DEDEPEND="${DEPEND}
	>=sys-devel/gettext-0.10.38[${MULTILIB_USEDEP}]"

case "${EAPI:-5}" in
	4|5) EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install pkg_postinst;;
	*) die "EAPI=\"${EAPI}\" is not supported";;
esac

# @ECLASS-VARIABLE: PRINTER_USE
# @DESCRIPTION: An array with printers USE flags

# @ECLASS-VARIABLE: PRINTER_ID
# @DESCRIPTION: An array with printers id

# @FUNCTION: dir_src_prepare
# @DESCRIPTION:
dir_src_command() {
	local dirs="${1}" cmd="${2}" args="${3}"
	[[ $# < 2 ]] && eeror "invalid number of argument" && return 1

	for dir in ${dirs}; do
		pushd ${dir} || die
		if [[ x${cmd} == xeautoreconf ]]; then
			[[ -d configures ]] && cp -f configures/configure.in.new configure.in
			[[ -d po ]] && echo "no" | glib-gettextize --force --copy
			${cmd} ${args}
		elif [[ x${cmd} == xeconf ]]; then
			[[ x${dir} == xcnijfilter ]] &&
				myeconfargs=( "--enable-libpath=/usr/$(get_libdir)/cnijlib" ${myeconfargs[@]} )
			${cmd} ${args} ${myeconfargs[@]}
		else
			${cmd} ${args}
		fi
		popd || die
	done
}

# @FUNCTION: ecnij_pkg_setup
# @DESCRIPTION:
ecnij_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ -z ${LINGUAS} ]] && export LINGUAS="en"

	use abi_x86_32 && use amd64 && multilib_toolchain_setup "x86"

	CNIJFILTER_SRC="libs pstocanonij"
	PRINTER_SRC="cnijfilter"
	use usb && CNIJFILTER_SRC+=" backend"
	use_if_iuse net && CNIJFILTER_SRC+=" backendnet"
	if use gtk; then
		CNIJFILTER_SRC+=" cngpij"
		if version_is_at_least 4.00; then
			PRINTER_SRC+=" lgmon2"
			use net && PRINTER_SRC+=" cnijnpr"
		else
			PRINTER_SRC+=" lgmon cngpijmon"
			use_if_iuse net && PRINTER_SRC+=" cngpijmon/cnijnpr"
		fi
	fi
	use servicetools &&
	if   version_is_at_least 4.00; then
		PRINTER_SRC+=" cngpijmnt"
	elif version_is_at_least 3.80; then
		PRINTER_SRC+=" cngpijmnt maintenance"
	else
		PRINTER_SRC+=" printui"
	fi

	if version_is_at_least 4.00; then
		CNIJFILTER_SRC="bscc2sts cmdtocanonij ${CNIJFILTER_SRC} cnijbe"
	fi
}

# @FUNCTION: ecnij_src_unpack
# @DESCRIPTION:
ecnij_src_unpack() {
	debug-print-function ${FUNCNAME} "${@}"

	default
	cd "${S}"
}

# @FUNCTION: ecnij_src_prepare
# @DESCRIPTION: prepare environment and run elibtoolize.
ecnij_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ ${PATCHES} ]] && epatch "${PATCHES[@]}"

	epatch_user

	dir_src_command "${CNIJFILTER_SRC}" "eautoreconf"

	local p pr prid
	for (( p=0; p<${#PRINTER_ID[@]}; p++ )); do
		pr=${PRINTER_USE[$p]} prid=${PRINTER_ID[$p]}
		if use ${pr}; then
			mkdir ${pr} || die
			for dir in ${prid} ${PRINTER_SRC}; do
				cp -a ${dir} ${pr} || die
			done
			pushd ${pr} || die
			[[ -d ../com ]] && ln -s {../,}com
			dir_src_command "${PRINTER_SRC}" "eautoreconf"
			popd
		fi
	done
}

# @FUNCTION: ecnij_src_configure
# @DESCRIPTION:
ecnij_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	dir_src_command "${CNIJFILTER_SRC}" "econf"

	local p pr prid
	for (( p=0; p<${#PRINTER_ID[@]}; p++ )); do
		pr=${PRINTER_USE[$p]} prid=${PRINTER_ID[$p]}
		if use ${pr}; then
			pushd ${pr} || die
			dir_src_command "${PRINTER_SRC}" \
				"econf" "--program-suffix=${pr}"
			popd
		fi
	done
}

# @FUNCTION: ecnij_src_compile
# @DESCRIPTION:
ecnij_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	local p pr prid
	for (( p=0; p<${#PRINTER_ID[@]}; p++ )); do
		pr=${PRINTER_USE[$p]} prid=${PRINTER_ID[$p]}
		if use ${pr}; then
			pushd ${pr} || die
			dir_src_command "${PRINTER_SRC}" "emake"
			popd
		fi
	done

	dir_src_command "${CNIJFILTER_SRC}" "emake"
}

# @FUNCTION: ecnij_src_install
# @DESCRIPTION:
ecnij_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	local abi_libdir=/usr/$(get_libdir) p pr prid
	local abi_lib=${abi_libdir#*lib}

	[[ ${PRINTER_MULTILIB} ]] || abi_lib=

	dir_src_command "${CNIJFILTER_SRC}" "emake" "DESTDIR=\"${D}\" install"

	mkdir -p "${ED}"${abi_libdir}/cnijlib &&
	for (( p=0; p<${#PRINTER_ID[@]}; p++ )); do
		pr=${PRINTER_USE[$p]} prid=${PRINTER_ID[$p]}
		if use ${pr}; then
			pushd ${pr} || die
			dir_src_command "${PRINTER_SRC}" "emake" "DESTDIR=\"${D}\" install"
			popd

			dolib.so ${prid}/libs_bin${abi_lib}/*.so*
			dosym ${abi_libdir}/{cnij,bj}lib
			exeinto ${abi_libdir}/cnijlib
			doexe ${prid}/database/*
			insinto /usr/share/cups/model
			doins ppd/canon${pr}.ppd

			use_if_iuse doc &&
			for lingua in ${LINGUAS}; do
				dodoc lproptions/lproptions-${pr}-${PV}${lingua^^[a-z]}.txt
			done
		fi
	done

	if use_if_iuse net; then
		dolib.so com/libs_bin${abi_lib}/*.so*
		EXEOPTIONS="-m555 -glp -olp"
		exeinto ${abi_libdir}/cnijlib
		doexe com/ini/cnnet.ini
	fi

	local license lingua
	for lingua in ${LINGUAS}; do
		license=LICENSE-${MY_PN}-${PV}${lingua^^[a-z]}.txt
		[[ -e ${license} ]] && dodoc ${license}
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
