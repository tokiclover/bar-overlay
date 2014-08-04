# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: eclass/ecnij.eclass,v 1.2 2014/07/15 19:33:34 -tclover Exp $

# @ECLASS: ecnij.eclass
# @MAINTAINER: tclover@bar-overlay
# @BLURB: 
# @DESCRIPTION: Exports portage base functions used by ebuilds 
# written for net-print/cnijfilter packages

inherit autotools eutils flag-o-matic multilib-build

IUSE="${IUSE} debug gtk nls servicetools usb"
KEYWORDS="~x86 ~amd64"

REQUIRED_USE="${REQUIRED_USE} servicetools? ( gtk ) nls? ( gtk )"

has net ${IUSE} && REQUIRED_USE+=" servicetools? ( net )"

RDEPEND="${RDEPEND}
	app-text/ghostscript-gpl[${MULTILIB_USEDEP}]
	dev-libs/glib[${MULTILIB_USEDEP}]
	dev-libs/popt[${MULTILIB_USEDEP}]
	servicetools? ( 
		>=gnome-base/libglade-0.6[${MULTILIB_USEDEP}]
		>=dev-libs/libxml-1.8[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}] )"

if [[ ${PV:0:1} -eq 3 ]] && [[ ${PV:2:2} -ge 40 ]]; then
	RDEPEND="${RDEPEND}
		>=media-libs/tiff-3.4[${MULTILIB_USEDEP}]
		>=media-libs/libpng-1.0.9[${MULTILIB_USEDEP}]"
else 
	use amd64 && multilib_toolchain_setup "x86"
	RDEPEND="${RDEPEND}
		sys-libs/lib-compat[${MULTILIB_USEDEP}]"
fi

DEDEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.10.38[${MULTILIB_USEDEP}] )"

case "${EAPI:-4}" in
	0|1) EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install pkg_postinst;;
	2|3|4|5) EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install pkg_postinst;;
	*) die "EAPI=\"${EAPI}\" is not supported";;
esac

# @ECLASS-VARIABLE: ECNIJ_PRUSE
# @DESCRIPTION: An array with printers USE flags

# @ECLASS-VARIABLE: ECNIJ_PRID
# @DESCRIPTION: An array with printers id

# @ECLASS-VARIABLE: ECNIJ_PRN
# @DESCRIPTION: an integer variable used for iterrations

# @ECLASS-VARIABLE: ECNIJ_PRCOM
# @DESCRIPTION: An array with printer commercial names

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

	use usb && ECNIJ_SRC+=" backend"
	if use gtk; then
		ECNIJ_SRC+=" cngpijmon"
		ECNIJ_PRSRC+=" lgmon"
		use_if_iuse net && ECNIJ_SRC+=" cngpijmon/cnijnpr"
	fi
	use servicetools && ECNIJ_PRSRC+=" printui"
	use_if_iuse net && ECNIJ_SRC+=" backendnet"
	ECNIJ_PRN="$(seq 0 $((${#ECNIJ_PRUSE[@]}-1)))"
	if [[ -z "${ECNIJ_PRCOM}" ]]; then
		local p prn
		declare -a ECNIJ_PRCOM
		for p in ${ECNIJ_PRN}; do
			prn=${ECNIJ_PRUSE[$p]//[0-9]/}
			ECNIJ_PRCOM[$p]="PIXUS/PIXMA ${prn^[a-z]}-series"
		done
	fi

	local a=true p
	for p in ${ECNIJ_PRN}; do
		einfo " ${ECNIJ_PRUSE[$p]}\t${ECNIJ_PRCOM[$p]}"
		if (use ${ECNIJ_PRUSE[$p]}); then
			a=false
		fi
	done
	if ${a}; then
		einfo ""
		ewarn "You didn't specify any printer model (USE flag)"
		einfo "to get ${ECNIJ_PRUSE[1]} support, for example, USE=\"${ECNIJ_PRUSE[1]}\""
		einfo ""
		die
	fi
}

# @FUNCTION: ecnij_src_unpack
# @DESCRIPTION:
ecnij_src_unpack() {
	debug-print-function ${FUNCNAME} "${@}"

	default
	cd "${S}"
}

# @FUNCTION: _src_prepare
# @DESCRIPTION:
_src_prepare() {
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

	for dir in libs cngpij ${ECNIJ_SRC} pstocanonij; do
		pushd ${dir} || die
		_src_prepare
		popd
	done

	local p pr prid
	for p in ${ECNIJ_PRN}; do
		pr=${ECNIJ_PRUSE[$p]} prid=${ECNIJ_PRID[$p]}
		if use ${pr}; then
			mkdir ${pr} || die
			for dir in ${prid} cnijfilter ${ECNIJ_PRSRC}; do
				cp -a ${dir} ${pr} || die
			done
			pushd ${pr} || die
			[[ -d ../com ]] && ln -s {../,}com
			ecnij_src_pr-prepare
			popd
		fi
	done
}

# @FUNCTION: ecnij_src_configure
# @DESCRIPTION:
ecnij_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	for dir in libs cngpij ${ECNIJ_SRC} pstocanonij; do
		pushd ${dir} || die
		econf --prefix=/usr "${myeconfargs[@]}"
		popd
	done

	mv {,_}lgmon || die
	local p pr prid
	for p in ${ECNIJ_PRN}; do
		pr=${ECNIJ_PRUSE[$p]} prid=${ECNIJ_PRID[$p]}
		if use ${pr}; then
			ln -sf ${pr}/lgmon lgmon
			pushd ${pr} || die
			ecnij_src_pr-configure
			popd
		fi
	done
}

# @FUNCTION: ecnij_src_compile
# @DESCRIPTION:
ecnij_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	local p pr prid
	for p in ${ECNIJ_PRN}; do
		pr=${ECNIJ_PRUSE[$p]} prid=${ECNIJ_PRID[$p]}
		if use ${pr}; then
			pushd ${pr} || die
			ecnij_src_pr-compile
			popd
		fi
	done

	for dir in libs cngpij ${ECNIJ_SRC} pstocanonij; do
		pushd ${dir} || die
		emake || die
		popd
	done
}

# @FUNCTION: ecnij_src_install
# @DESCRIPTION:
ecnij_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	local abi_libdir=/usr/$(get_abi_libdir) bindir=/usr/bin p pr prid
	local libexecdir=/usr/libexec/cups modeldir=/usr/share/cups/model
	local abi_lib=$(echo $abi_libdir | cut -b9-) olddir=/usr/lib/cups
	mkdir -p "${D}"{${abi_libdir}/bjlib,${libexecdir}/{backend,filter}}

	for dir in libs cngpij ${ECNIJ_SRC} pstocanonij; do
		pushd ${dir} || die
		emake DESTDIR="${D}" install || die
		popd
	done

	for p in ${ECNIJ_PRN}; do
		pr=${ECNIJ_PRUSE[$p]} prid=${ECNIJ_PRID[$p]}
		if use ${pr}; then
			pushd ${pr} || die
			ecnij_src_pr-install
			popd

			dolib.so ${prid}/libs_bin${abi_lib}/*.so
			install -m644 ${prid}/database/* "${D}${abi_libdir}"/bjlib || die
			install -Dm644 ppd/canon${pr}.ppd "${D}${modeldir}"/canon${pr}.ppd || die
		fi
	done

	if use_if_iuse net; then
		dolib.so com/libs_bin${abi_lib}/*.so
		install -Dm644 -glp -olp com/ini/cnnet.ini "${D}${abi_libdir}"/bjlib || die
	fi
	for dir in backend filter; do
		mv "${D}"${olddir}/${dir}/* "${D}"${libexecdir}/${dir} || die
		rmdir "${D}"${olddir}/${dir}

	done
}
# @FUNCTION: ecnij_{prepare,configure,compile,install}_pr
# @DESCRIPTION: internal functions
ecnij_src_pr-prepare() {
	for dir in cnijfilter ${ECNIJ_PRSRC}; do
		pushd ${dir} || die
		_src_prepare
		popd
	done
}
ecnij_src_pr-configure() {
	for dir in cnijfilter ${ECNIJ_PRSRC}; do
		pushd ${dir} || die
		econf --program-suffix=${pr} --prefix=/usr
		popd
	done
}
ecnij_src_pr-compile() {
	for dir in cnijfilter ${ECNIJ_PRSRC}; do
		pushd ${dir} || die
		emake ${myconf} || die "${dir}: emake failed"
		popd
	done
}
ecnij_src_pr-install() {
	for dir in cnijfilter ${ECNIJ_PRSRC}; do
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
