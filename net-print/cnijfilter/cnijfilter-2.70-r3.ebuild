# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-2.70-r3.ebuild,v 1.5 2012/05/30 12:05:58 -tclover Exp $

EAPI=4

inherit eutils autotools rpm flag-o-matic

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
DOWNLOAD_URL="http://software.canon-europe.com/software/0027403.asp"
SRC_URI="${PN}-common-${PV}-2.src.rpm"
RESTRICT="fetch nomirror confcache"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

WANT_AUTOCONF=2.59
WANT_AUTOMAKE=1.9.6

SLOT="2.70"
KEYWORDS="~x86 ~amd64"
IUSE="+debug amd64 servicetools gtk mp160 ip3300 mp510 ip4300 mp600 ip2500 ip1800 ip90"
REQUIRED_USE="servicetools? ( gtk )"
[ "${ARCH}" == "amd64" ] && REQUIRED_USE+=" servicetools? ( amd64 )"

DEPEND="app-text/ghostscript-gpl
	gtk? ( >=sys-devel/gettext-0.10.38
		dev-util/intltool
		app-emulation/emul-linux-x86-gtklibs )
	app-text/ghostscript-gpl
	>=net-print/cups-1.1.14
	!amd64? ( sys-libs/glibc
		>=dev-libs/popt-1.6
		>=media-libs/tiff-3.4
		>=media-libs/libpng-1.0.9 )
	amd64? ( app-emulation/emul-linux-x86-popt
		app-emulation/emul-linux-x86-compat
		app-emulation/emul-linux-x86-baselibs )
	servicetools? ( 
		!amd64? ( >=gnome-base/libglade-0.6
			>=dev-libs/libxml2-2.7.3-r2
			x11-libs/gtk+-:2 )
		amd64? ( app-emulation/emul-linux-x86-popt )
	)
"
S="${WORKDIR}"/${PN}-common-${PV}

_pruse=("mp160" "ip3300" "mp510" "ip4300" "mp600" "ip2500" "ip1800" "ip90")
_prname=(${_pruse[@]})
_prid=("291" "292" "293" "294" "295" "311" "312" "253")
_prcomp=("mp160" "ip3300" "mp510" "ip4300" "mp600" "ip2500series" "ip1800series" "ip90")
_max=$((${#_pruse[@]}-1))

pkg_nofetch() {
	einfo "Please download ${SRC_URI} manually from"
	einfo "${DOWNLOAD_URL} and extract it from that"
	einfo "and move it to ${DISTDIR}"
}

pkg_setup() {
	if [ -z "$LINGUAS" ]; then
		ewarn "You didn't specify 'LINGUAS' in your make.conf. Assuming"
		ewarn "english localisation, i.e. 'LINGUAS=\"en\"'."
		LINGUAS="en"
	fi

	use amd64 && multilib_toolchain_setup x86
	_src=cngpij
	_prsrc=cnijfilter
	use gtk && _src+=" cngpijmon"
	use servicetools && _prsrc+=" printui lgmon"
	
	_autochoose="true"
	for i in $(seq 0 ${_max}); do
		einfo " ${_pruse[$i]}\t${_prcomp[$i]}"
		if (use ${_pruse[$i]}); then
			_autochoose="false"
		fi
	done
	einfo ""
	if (${_autochoose}); then
		ewarn "You didn't specify any driver model (set it's USE-flag)."
		einfo ""
		einfo "As example:\tbasic MP160 support without maintenance tools"
		einfo "\t\t -> USE=\"mp160\""
		einfo ""
		einfo "Press Ctrl+C to abort"
		echo
		ebeep

		n=15
		while [[ $n -gt 0 ]]; do
			echo -en "  Waiting $n seconds...\r"
			sleep 1
			(( n-- ))
		done
	fi
}

src_prepare() {
	epatch ${FILESDIR}/${P%-r*}-1-common.patch || die
	epatch ${FILESDIR}/${P%-r*}-1-png_jmpbuf-fix.patch || die

	for dir in libs ${_src} pstocanonij; do
		pushd ${dir} || die
		[ -d configures ] && mv -f configures/configure.in.new configure.in
		[ -d po ] && intltoolize --copy --force --automake
		autotools_run_tool libtoolize --copy --force --automake
		eaclocal
		eautoheader
		eautomake --gnu
		eautoreconf
		pushd
	done

	for i in $(seq 0 ${_max}); do
		if use ${_pruse[$i]} || ${_autochoose}; then
			_pr=${_prname[$i]} _prid=${_prid[$i]}
			src_prepare_pr
		fi
	done
}

src_configure() {
	for dir in libs ${_src} pstocanonij; do
		pushd ${dir} || die
		econf 
		pushd
	done

	for i in $(seq 0 ${_max}); do
		if use ${_pruse[$i]} || ${_autochoose}; then
			_pr=${_prname[$i]} _prid=${_prid[$i]}
			src_configure_pr
		fi
	done
}

src_compile() {
	for dir in libs ${_src} pstocanonij; do
		pushd ${dir} || die
		emake
		pushd
	done

	for i in $(seq 0 ${_max}); do
		if use ${_pruse[$i]} || ${_autochoose}; then
			_pr=${_prname[$i]} _prid=${_prid[$i]}
			src_compile_pr
		fi
	done
}

src_install() {
	local _libdir=/usr/$(get_libdir) _ppddir=/usr/share/cups/model
	local _cupsdir=/usr/libexec/cups/filter
	mkdir -p "${D}${_libdir}"/cups/filter || die
	mkdir -p "${D}${_libdir}"/cnijlib || die
	mkdir -p "${D}${_cupsdir}" || die
	mkdir -p "${D}${_ppddir}"
	for dir in libs ${_src} pstocanonij; do
		pushd ${dir} || die
		emake DESTDIR="${D}" install || die
		pushd
	done

	for i in $(seq 0 ${_max}); do
		if use ${_pruse[$i]} || ${_autochoose}; then
			_pr=${_prname[$i]} _prid=${_prid[$i]}
			src_install_pr
		fi
	done

	mv "${D}${_libdir}"/cups/filter/pstocanonij \
		"${D}${_cupsdir}/pstocanonij${SLOT}" && rm -fr "${D}${_libdir}"/cups || die
	mv "${D}"/usr/bin/cngpij{,${SLOT}} || die
}

pkg_postinst() {
	einfo ""
	einfo "For installing a printer:"
	einfo " * Restart CUPS: /etc/init.d/cupsd restart"
	einfo " * Go to http://127.0.0.1:631/"
	einfo "   -> Printers -> Add Printer"
	einfo ""
	einfo "If you experience any problems, please visit:"
	einfo " http://forums.gentoo.org/viewtopic-p-3217721.html"
	einfo "https://bugs.gentoo.org/show_bug.cgi?id=258244"
}

src_prepare_pr() {
	mkdir ${_pr}
	for dir in ${_prid} ${_prsrc}; do
		cp -a ${dir} ${_pr} || die
	done

	for dir in ${_prsrc}; do
		cd ${dir} || die
		[ -d configures ] && mv -f configures/configure.in.new configure.in
		[ -d po ] && intltoolize --copy --force --automake
		autotools_run_tool libtoolize --copy --force --automake
		eaclocal
		eautoheader
		eautomake --gnu
		eautoreconf
		cd ..
	done
}

src_configure_pr() {
	for dir in ${_prsrc}; do
		cd ${dir} || die
		econf --program-suffix=${_pr}
		cd ..
	done
}

src_compile_pr() {
	for dir in ${_prsrc}; do
		cd ${dir} || die
		emake || die "${dir}: emake failed"
		cd ..
	done
}

src_install_pr() {
	for dir in ${_prsrc}; do
		cd ${dir} || die
		emake DESTDIR="${D}" install || die "${dir}: emake install failed"
		cd ..
	done

	cp -a ${_prid}/libs_bin/* "${D}${_libdir}" || die
	cp -a ${_prid}/database/* "${D}${_libdir}"/cnijlib || die
	cp -a ppd/canon${_pr}.ppd "${D}${_ppddir}" || die
}
