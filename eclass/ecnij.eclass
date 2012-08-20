# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/eclass/ecnij.eclass,v 1.1 2012/08/20 23:32:05 -tclover Exp $

# @ECLASS: ecnij.eclass
# @MAINTAINER:
# tclover@bar-overlay
# @BLURB: 
# @DESCRIPTION:
# Exports portage base functions used by ebuilds written for net-print/cnijfilter packages

inherit autotools eutils flag-o-matic

WANT_AUTOCONF=${E_WANT_AUTOCONF:-latest}
WANT_AUTOMAKE=${E_WANT_AUTOMAKE:-latest}

IUSE="+debug gtk nls servicetools usb"
KEYWORDS="-* ~x86 ~amd64"

REQUIRED_USE="servicetools? ( gtk ) nls? ( gtk )"

has net ${IUSE} && REQUIRED_USE+=" servicetools? ( net )"

DEPEND="app-text/ghostscript-gpl
	>=net-print/cups-1.1.14
	sys-libs/glibc
	nls? ( >=sys-devel/gettext-0.10.38 )
	servicetools? ( 
		>=gnome-base/libglade-0.6
		>=dev-libs/libxml-1.8
	)
"
if [[ "${PV:0:1}" -eq "3" ]] && [[ "${PV:2:2}" -ge "40" ]]; then
	DEPEND="${DEPEND}
		>=dev-libs/popt-1.6
		>=media-libs/tiff-3.4
		>=media-libs/libpng-1.0.9
		gtk? ( x11-libs/gtk+:2 )
	"
else 
	DEPEND="${DEPEND}
		app-emulation/emul-linux-x86-popt
		app-emulation/emul-linux-x86-compat
		app-emulation/emul-linux-x86-baselibs
		gtk? ( app-emulation/emul-linux-x86-gtklibs )
	"
	has amd64 ${IUSE} && REQUIRED_USE+=" servicetools? ( amd64 )"
fi

case "${EAPI:-4}" in
	0|1) EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install pkg_postinst;;
	2|3|4) EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile src_install pkg_postinst;;
	*) die "EAPI=${EAPI} is not supported";;
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
	has amd64 ${IUSE} && use amd64 && multilib_toolchain_setup x86
	use usb && ECNIJ_SRC+=" backend"
	use gtk && ECNIJ_SRC+=" cngpijmon" ECNIJ_PRSRC+=" lgmon"
	use servicetools && ECNIJ_PRSRC+=" printui"
	has net ${IUSE} && use net && ECNIJ_SRC+=" backendnet"
	use gtk && has net ${IUSE} && use net && ECNIJ_SRC+=" cngpijmon/cnijnpr"

	ECNIJ_PRN="$(seq 0 $((${#ECNIJ_PRUSE[@]}-1)))"
	if [[ -z "${ECNIJ_PRCOM}" ]]; then declare -a ECNIJ_PRCOM
		for p in ${ECNIJ_PRN}; do
			ECNIJ_PRCOM[p]="${ECNIJ_PRUSE[$p]}series"
		done
	fi

	local ac="true"
	for p in ${ECNIJ_PRN}; do
		einfo " ${ECNIJ_PRUSE[$p]}\t${ECNIJ_PRCOM[$p]}"
		if (use ${ECNIJ_PRUSE[$p]}); then
			ac="false"
		fi
	done
	if ${ac}; then
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
	unpack ${A}
	cd "${S}"
}

# @FUNCTION: ecnij_src_prepare
# @DESCRIPTION: prepare environment and run elibtoolize.
ecnij_src_prepare() {
	if has ${EAPI:-0} 0 1; then
		local et="nonfatal elibtoolize"
	else et="autotools_run_tool libtoolize"; fi

	for dir in libs cngpij ${ECNIJ_SRC} pstocanonij; do
		pushd ${dir} || die
		[ -d configures ] && mv -f configures/configure.in.new configure.in
		use nls && [ -d po ] && echo "no" | glib-gettextize ${EGTCONF}
		${et} ${ELTCONF}
		eaclocal
		eautoheader
		eautomake --gnu
		eautoreconf
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
			[[ "${PV:0:1}" -eq "3" ]] && [[ "${PV:2:2}" -ge "10" ]] && ln -s {../,}com
			ecnij_src_prepare_pr
			popd
		fi
	done
}

# @FUNCTION: ecnij_src_configure
# @DESCRIPTION:
ecnij_src_configure() {
	for dir in libs cngpij ${ECNIJ_SRC} pstocanonij; do
		pushd ${dir} || die
		econf --prefix=/usr ${MY_ECONF}
		popd
	done

	mv {,_}lgmon || die
	local pr prid
	for p in ${ECNIJ_PRN}; do
		pr=${ECNIJ_PRUSE[$p]} prid=${ECNIJ_PRID[$p]}
		if use ${pr}; then
			ln -sf ${pr}/lgmon lgmon
			pushd ${pr} || die
			ecnij_src_configure_pr
			popd
		fi
	done
}

# @FUNCTION: ecnij_src_compile
# @DESCRIPTION:
ecnij_src_compile() {
	local p pr prid
	for p in ${ECNIJ_PRN}; do
		pr=${ECNIJ_PRUSE[$p]} prid=${ECNIJ_PRID[$p]}
		if use ${pr}; then
			pushd ${pr} || die
			ecnij_src_compile_pr
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
	local ldir=/usr/$(get_libdir) le=/usr/libexec/cups/ pdir=/usr/share/cups/model
	local bindir=/usr/bin odir=${ldir}/cups/filter bdir=${le}backend fdir=${le}filter
	local arc p pr prid slot _dir=/usr/lib/cups/backend
	mkdir -p "${D}"{${ldir}/bjlib,${bdir},${fdir}}

	if [[ "${PV:0:1}" -eq "3" ]] && [[ "${PV:2:2}" -ge "40" ]]; then
		[ -n "$(uname -m | grep 64)" ] && arc=64 || arc=32
	fi

	for dir in libs cngpij ${ECNIJ_SRC} pstocanonij; do
		pushd ${dir} || die
		emake DESTDIR="${D}" install || die
		popd
	done

	for p in ${ECNIJ_PRN}; do
		pr=${ECNIJ_PRUSE[$p]} prid=${ECNIJ_PRID[$p]}
		if use ${pr}; then
			pushd ${pr} || die
			ecnij_src_install_pr
			popd

			cp -a ${prid}/libs_bin${arc}/* "${D}${ldir}" || die
			install -m644 ${prid}/database/* "${D}${ldir}"/bjlib || die
			install -Dm644 ppd/canon${pr}.ppd "${D}${pdir}"/canon${pr}.ppd || die
		fi
	done

	if has net ${IUSE} && use net; then
		dolib.so com/libs_bin${arc}/* || die
		install -Dm644 -glp -olp com/ini/cnnet.ini "${D}${ldir}"/bjlib || die
	fi
	rm -fr "${D}{${odir},${_dir}}"
}
# @FUNCTION: ecnij_{prepare,configure,compile,install}_pr
# @DESCRIPTION: internal functions
ecnij_src_prepare_pr() {
	for dir in cnijfilter ${ECNIJ_PRSRC}; do
		pushd ${dir} || die
		[ -d configures ] && mv -f configures/configure.in.new configure.in
		use nls && [ -d po ] && echo "no" | glib-gettextize ${EGTCONF}
		autotools_run_tool libtoolize ${ELTCONF}
		eaclocal
		eautoheader
		eautomake --gnu
		eautoreconf
		popd
	done
}
ecnij_src_configure_pr() {
	for dir in cnijfilter ${ECNIJ_PRSRC}; do
		pushd ${dir} || die
		econf --program-suffix=${pr} --prefix=/usr
		popd
	done
}
ecnij_src_compile_pr() {
	for dir in cnijfilter ${ECNIJ_PRSRC}; do
		pushd ${dir} || die
		emake ${myconf} || die "${dir}: emake failed"
		popd
	done
}
ecnij_src_install_pr() {
	for dir in cnijfilter ${ECNIJ_PRSRC}; do
		pushd ${dir} || die
		emake DESTDIR="${D}" install || die "${dir}: emake install failed"
		popd
	done
}

# @FUNCTION: ecnij_pkg_postinst
# @DESCRIPTION: output some usefull info
ecnij_pkg_postinst() {
	einfo ""
	einfo "For installing a printer:"
	einfo " * Restart CUPS: /etc/init.d/cupsd restart"
	einfo " * Go to http://127.0.0.1:631/"
	einfo "   -> Printers -> Add Printer"
	einfo ""
	einfo "If you experience any problems, please visit:"
	einfo "http://forums.gentoo.org/viewtopic-p-3217721.html"
	einfo "https://bugs.gentoo.org/show_bug.cgi?id=258244"
}
