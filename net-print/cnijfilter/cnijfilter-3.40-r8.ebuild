# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-3.40-r7.ebuild,v 1.3 2012/05/29 00:04:17 -tclover Exp $

EAPI=4

inherit eutils autotools rpm flag-o-matic

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://software.canon-europe.com/software/0040245.asp"
RESTRICT="nomirror confcache"

SRC_URI="http://files.canon-europe.com/files/soft40245/software/${PN}-source-${PV}-1.tar.gz"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

WANT_AUTOCONF=2.59
WANT_AUTOMAKE=1.9.6

SLOT="3.40"
KEYWORDS="~x86 ~amd64"
IUSE="+debug servicetools gtk net usb mp250 mp280 mp495 mg5100 mg5200 ip4800 mg6100 mg8100"
REQUIRED_USE="servicetools? ( gtk )
	|| ( net usb )
"
DEPEND="gtk? ( >=x11-libs/gtk+-2.6.0:2 )
	app-text/ghostscript-gpl
	>=net-print/cups-1.1.14
	sys-libs/glibc
	>=dev-libs/popt-1.6
	>=media-libs/tiff-3.4
	>=media-libs/libpng-1.0.9
	servicetools? ( 
		>=gnome-base/libglade-0.6
		>=dev-libs/libxml2-2.7.3-r2
	)
	>=sys-devel/gettext-0.10.38
	dev-util/intltool
"

S="${WORKDIR}"/${PN}-source-${PV}-1

_pruse=("mp250" "mp495" "mp280" "mg5100" "mg5200" "ip4800" "mg6100" "mg8100")
_prname=(${_pruse[@]})
_prid=("356" "369" "370" "373" "374" "375" "376" "377")
_prcomp=("mp250series" "mp495series" "mp280series" "mg5100series" "mg5200series" "ip4800series" "mg6100series" "mg8100series")
_max=$((${#_pruse[@]}-1))

pkg_setup() {
	if [ -z "$LINGUAS" ]; then
		ewarn "You didn't specify 'LINGUAS' in your make.conf. Assuming"
		ewarn "english localisation, i.e. 'LINGUAS=\"en\"'."
		LINGUAS="en"
	fi

	[ -n "$(uname -m | grep 64)" ] && _arch=64 || _arch=32

	use usb && _backend+=" backend"
	use net && _backend+=" backendnet"
	_cngpij+=" cngpij"
	use gtk && _cngpij+=" cngpijmon"
	use gtk && use net && _cngpij+=" cngpijmon/cnijnpr"
	
	_autochoose="true"
	for i in `seq 0 ${_max}`; do
		einfo " ${_pruse[$i]}\t${_prcomp[$i]}"
		if (use ${_pruse[$i]}); then
			_autochoose="false"
		fi
	done
	einfo ""
	if (${_autochoose}); then
		ewarn "You didn't specify any driver model (set it's USE-flag)."
		einfo ""
		einfo "As example:\tbasic MP280 support without maintenance tools"
		einfo "\t\t -> USE=\"mp280\""
		einfo ""
		einfo "Press Ctrl+C to abort"
		echo

		n=10
		while [[ $n -gt 0 ]]; do
			echo -en "  Waiting $n seconds...\r"
			sleep 1
			(( n-- ))
		done
	fi
}

src_prepare() {
	epatch ${FILESDIR}/${PN}-${PV/40/20}-4-cups_ppd.patch || die
	epatch ${FILESDIR}/${P%-r*}-8-ldl.patch || die
	epatch ${FILESDIR}/${PN}-${PV/40/20}-4-libpng15.patch || die

	for dir in libs ${_backend} ${_cngpij} pstocanonij; do
		pushd ${dir} || die
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
	for dir in libs ${_backend} ${_cngpij} pstocanonij; do
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
	for dir in libs ${_backend} ${_cngpij} pstocanonij; do
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
	local _cupsdir=/usr/libexec/cups/filter _cupsodir=/usr/lib/cups/backend
	mkdir -p "${D}${_libdir}"/cups/filter || die
	mkdir -p "${D}${_libdir}"/cnijlib || die
	mkdir -p "${D}${_cupsdir}" || die
	mkdir -p "${D}${_ppddir}"
	for dir in libs ${_backend} ${_cngpij} pstocanonij; do
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
	use usb && mv "${D}${_cupsodir}"/cnijusb "${D}${_cupsdir}"/cnijusb${SLOT} || die
	if use net; then
		mv "${D}"/usr/bin/cnijnetprn{,${SLOT}} || die
		mv "${D}${_cupsodir}"/cnijnet "${D}${_cupsdir}"/cnijnet${SLOT} || die
		use gtk && cp -a com/libs_bin${_arch}/* "${D}${_libdir}" || die
	fi
	rm -fr "${D}"/usr/lib/cups/backend
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
	cp -a ${_prid} ${_pr} || die
	cp -a cnijfilter ${_pr} || die
	cp -a printui ${_pr} || die
	cp -a lgmon ${_pr} || die
	use gtk && use net && cp -a com ${_pr} || die

	cd ${_pr}/cnijfilter || die
	autotools_run_tool libtoolize --copy --force --automake
	eaclocal
	eautoheader
	eautomake --gnu
	eautoreconf
	cd ..

	if use servicetools; then
		for dir in printui lgmon; do
			cd ${dir} || die
			[ -d po ] && intltoolize --copy --force --automake
			autotools_run_tool libtoolize --copy --force --automake
			eaclocal
			eautoheader
			eautomake --gnu
			eautoreconf
			cd ..
		done
	fi
}

src_configure_pr() {
	cd ${_pr}/cnijfilter || die
	econf --program-suffix=${_pr}
	cd ..

	if use servicetools; then
		for dir in printui lgmon; do
			cd ${dir} || die
			econf --program-suffix=${_pr}
			cd ..
		done
	fi
}

src_compile_pr() {
	cd ${_pr}/cnijfilter || die
	emake || die "couldn't make ${_pr}/cnijfilter"
	cd ..

	if use servicetools; then
		for dir in printui lgmon; do
			cd ${dir} || die
			emake || die "couldn't make ${_pr}/${dir}"
			cd ..
		done
	fi
}

src_install_pr() {
	cd ${_pr}/cnijfilter || die
	emake DESTDIR="${D}" install || die "couldn't make install ${_pr}/cnijfilter"
	cd ..

	if use servicetools; then
		for dir in printui lgmon; do
			cd ${dir} || die
			emake DESTDIR="${D}" install || die "couldn't make install ${_pr}/${dir}"
			cd ..
		done
	fi

	cd ..
	cp -a ${_prid}/libs_bin${_arch}/* "${D}${_libdir}" || die
	cp -a ${_prid}/database/* "${D}${_libdir}"/cnijlib || die
	cp -a ppd/canon${_pr}.ppd "${D}${_ppddir}" || die
}
