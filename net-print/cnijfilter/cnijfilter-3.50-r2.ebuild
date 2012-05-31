# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-3.50.ebuild,v 1.5 2012/05/31 15:59:45 -tclover Exp $

EAPI=4

inherit eutils autotools rpm flag-o-matic

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://software.canon-europe.com/software/0040869.asp"
RESTRICT="nomirror confcache"

SRC_URI="http://files.canon-europe.com/files/soft40869/software/${PN}-source-${PV}-1.tar.gz"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

WANT_AUTOCONF=2.59
WANT_AUTOMAKE=1.9.6

SLOT="3.50"
KEYWORDS="~x86 ~amd64"
IUSE="+debug servicetools gtk net usb mx360 mx410 mx420 mx880 ix6500"
REQUIRED_USE="servicetools? ( gtk )"
DEPEND="app-text/ghostscript-gpl
	gtk? ( >=sys-devel/gettext-0.10.38
		>=x11-libs/gtk+-2.6.0:2 )
	>=net-print/cups-1.1.14
	sys-libs/glibc
	>=dev-libs/popt-1.6
	>=media-libs/tiff-3.4
	>=media-libs/libpng-1.0.9
	servicetools? (  >=gnome-base/libglade-0.6
		>=dev-libs/libxml2-2.7.3-r2 )
"

S="${WORKDIR}"/${PN}-source-${PV}-1

_pruse=("mx360" "mx410" "mx420" "mx880" "ix6500")
_prname=(${_pruse[@]})
_prid=("380" "381" "382" "383" "384")
_prcomp=("mx360series" "mx410series" "mx420series" "mx880series" "ix6500series")
_max=$((${#_pruse[@]}-1))

pkg_setup() {
	if [ -z "$LINGUAS" ]; then
		ewarn "You didn't specify 'LINGUAS' in your make.conf. Assuming"
		ewarn "english localisation, i.e. 'LINGUAS=\"en\"'."
		LINGUAS="en"
	fi

	[ -n "$(uname -m | grep 64)" ] && _arch=64 || _arch=32
	use usb && _src=backend
	use net && _src+=" backendnet"
	use gtk && _src+=" cngpijmon" _prsrc=lgmon
	use gtk && use net && _src+=" cngpijmon/cnijnpr"
	use servicetools && _prsrc+=" printui"
	
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
		einfo "As example:\tbasic MX360 support without maintenance tools"
		einfo "\t\t -> USE=\"mx360\""
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
	epatch "${FILESDIR}"/${PN}-${PV/50/20}-4-cups_ppd.patch || die
	epatch "${FILESDIR}"/${P%-r*}-1-ldl.patch || die
	epatch "${FILESDIR}"/${PN}-${PV/50/20}-4-libpng15.patch || die

	for dir in libs cngpij ${_src} pstocanonij; do
		pushd ${dir} || die
		[ -d po ] && echo "no" | glib-gettextize --force --copy
		autotools_run_tool libtoolize --copy --force --automake
		eaclocal
		eautoheader
		eautomake --gnu
		eautoreconf
		popd
	done

	for i in $(seq 0 ${_max}); do
		if use ${_pruse[$i]} || ${_autochoose}; then
			_pr=${_prname[$i]} _prid=${_prid[$i]}
			mkdir ${_pr}
			for dir in ${_prid} cnijfilter ${_prsrc}; do
				cp -a ${dir} ${_pr} || die
			done
			pushd ${_pr} || die
			src_prepare_pr
			popd
		fi
	done
}

src_configure() {
	for dir in libs cngpij ${_src} pstocanonij; do
		pushd ${dir} || die
		econf 
		popd
	done

	mv {,_}lgmon || die
	for i in $(seq 0 ${_max}); do
		if use ${_pruse[$i]} || ${_autochoose}; then
			_pr=${_prname[$i]} _prid=${_prid[$i]}
			ln -sf ${_pr}/lgmon lgmon
			pushd ${_pr} || die
			src_configure_pr
			popd
		fi
	done
}

src_compile() {
	for i in $(seq 0 ${_max}); do
		if use ${_pruse[$i]} || ${_autochoose}; then
			_pr=${_prname[$i]} _prid=${_prid[$i]}
			pushd ${_pr} || die
			src_compile_pr
			popd
		fi
	done

	for dir in libs cngpij ${_src} pstocanonij; do
		pushd ${dir} || die
		emake
		popd
	done
}

src_install() {
	local _libdir=/usr/$(get_libdir) _ppddir=/usr/share/cups/model \
		_cupsodir=/usr/lib/cups/backend
	local _cupsbdir=/usr/libexec/cups/backend _cupsfdir=/usr/libexec/cups/filter
	mkdir -p "${D}${_libdir}"/{cups/filter,cnijlib} || die
	mkdir -p "${D}"{${_cupsfdir},${_cupsbdir}} || die
	mkdir -p "${D}${_ppddir}"
	for dir in libs cngpij ${_src} pstocanonij; do
		pushd ${dir} || die
		emake DESTDIR="${D}" install || die
		popd
	done

	for i in $(seq 0 ${_max}); do
		if use ${_pruse[$i]} || ${_autochoose}; then
			_pr=${_prname[$i]} _prid=${_prid[$i]}
			pushd ${_pr} || die
			src_install_pr
			popd

			cp -a ${_prid}/libs_bin${_arch}/* "${D}${_libdir}" || die
			insinto "${_libdir}"/cnijlib
			doins ${_prid}/database/* || die
			
			sed -e "s/pstocanonij/pstocanonij${SLOT}/g" -i ppd/canon${_pr}.ppd || die
			cp -a ppd/canon${_pr}.ppd "${D}${_ppddir}" || die
		fi
	done

	mv "${D}${_libdir}"/cups/filter/pstocanonij \
		"${D}${_cupsfdir}/pstocanonij${SLOT}" && rm -fr "${D}${_libdir}"/cups || die
	mv "${D}"/usr/bin/cngpij{,${SLOT}} || die
	use usb && mv "${D}${_cupsodir}"/cnijusb "${D}${_cupsbdir}"/cnijusb${SLOT} || die
	use gtk && mv "${D}"/usr/bin/cnijnpr{,${SLOT}} || die
	if use net; then
		mv "${D}"/usr/bin/cnijnetprn{,${SLOT}} || die
		mv "${D}${_cupsodir}"/cnijnet "${D}${_cupsbdir}"/cnijnet${SLOT} || die
		dolib.so com/libs_bin${_arch}/* || die
		insinto /usr/lib/cnijlib
		insopts -m 644 -g lp -o lp
		doins com/ini/cnnet.ini || die
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
	for dir in cnijfilter ${_prsrc}; do
		pushd ${dir} || die
		[ -d po ] && echo "no" | glib-gettextize --force --copy
		autotools_run_tool libtoolize --copy --force --automake
		eaclocal
		eautoheader
		eautomake --gnu
		eautoreconf
		popd
	done
}

src_configure_pr() {
	for dir in cnijfilter ${_prsrc}; do
		pushd ${dir} || die
		econf --program-suffix=${_pr}
		popd
	done
}

src_compile_pr() {
	for dir in cnijfilter ${_prsrc}; do
		pushd ${dir} || die
		emake || die "${dir}: emake failed"
		popd
	done
}

src_install_pr() {
	for dir in cnijfilter ${_prsrc}; do
		pushd ${dir} || die
		emake DESTDIR="${D}" install || die "${dir}: emake install failed"
		popd
	done
}
