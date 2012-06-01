# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-3.40-r8.ebuild,v 1.6 2012/06/01 01:27:04 -tclover Exp $

EAPI=4

inherit eutils autotools rpm flag-o-matic

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://software.canon-europe.com/software/0040245.asp"
RESTRICT="nomirror confcache"

SRC_URI="http://files.canon-europe.com/files/soft40245/software/${PN}-source-${PV}-1.tar.gz
	scanner? ( http://gdlp01.c-wss.com/gds/3/0100003033/01/scangearmp-source-1.60-1.tar.gz )
"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

WANT_AUTOCONF=2.59
WANT_AUTOMAKE=1.9.6

SLOT="3.40"
KEYWORDS="~x86 ~amd64"
IUSE="+debug scanner servicetools gtk net usb mp250 mp280 mp495 mg5100 mg5200 ip4800 mg6100 mg8100"
REQUIRED_USE="servicetools? ( gtk ) scanner? ( gtk net )"
DEPEND="app-text/ghostscript-gpl
	gtk? ( >=sys-devel/gettext-0.10.38
		>=x11-libs/gtk+-2.6.0:2 )
	>=net-print/cups-1.1.14
	sys-libs/glibc
	>=dev-libs/popt-1.6
	>=media-libs/tiff-3.4
	>=media-libs/libpng-1.0.9
	servicetools? ( >=gnome-base/libglade-0.6
		>=dev-libs/libxml2-2.7.3-r2 )
	scanner? ( >=media-gfx/gimp-2.0.0 
		media-gfx/sane-backends
		dev-libs/libusb:0 )
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
	use usb && _src=backend
	use net && _src+=" backendnet"
	use gtk && _src+=" cngpijmon" _prsrc=lgmon
	use gtk && use net && _src+=" cngpijmon/cnijnpr"
	use servicetools && _prsrc+=" printui"
	use scanner && _scansrc="../scangearmp-source-1.60-1" _src+=" ${_scansrc}/scangearmp"
	
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
	epatch "${FILESDIR}"/${PN}-${PV/40/20}-4-cups_ppd.patch || die
	epatch "${FILESDIR}"/${P%-r*}-8-ldl.patch || die
	epatch "${FILESDIR}"/${PN}-${PV/40/20}-4-libpng15.patch || die
	if use scanner; then
		sed -i ${_scansrc}/scangearmp/backend/Makefile.am \
			-e "s:BACKEND_V_REV):BACKEND_V_REV) -L../../com/libs_bin${_arch}:" || die
		pushd ${_scansrc} && epatch "${FILESDIR}"/scangearmp-1.70-libpng15.patch && popd
	fi

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
			install -d "${D}${_libdir}"/cnijlib
			install -m644 ${_prid}/database/* "${D}${_libdir}"/cnijlib || die
			sed -e "s/pstocanonij/pstocanonij${SLOT}/g" -i ppd/canon${_pr}.ppd || die
			install -Dm644 ppd/canon${_pr}.ppd "${D}${_ppddir}"/${_pr}.ppd || die
			if use scanner; then
				install -m644 ${_scansrc}/${_prid}/*.tbl "${D}${_libdir}"/cnijlib || die
				dolib.so ${_scansrc}/${_prid}/libs_bin${_arch}/* || die
			fi
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
		install -m644 -glp -olp com/ini/cnnet.ini "${D}${_libdir}"/cnijlib || die
	fi
	if use scanner; then local _gimpdir=${_libdir}/gimp/2.0/plug-ins
		dolib.so ${_scansrc}/com/libs_bin${_arch}/* || die
		install -m644 -glp -olp ${_scansrc}/com/ini/canon_mfp_net.ini \
			"${D}${_libdir}"/cnijlib || die
		dosym ${_bindir}/scangearmp ${_gimpdir}/scangearmp${SLOT} || die
		if use usb; then 
			install -Dm644 ${_scansrc}/scangearmp/etc/80-canon_mfp.rules \
				"${D}"/etc/udev/rules.d/80-${PN}-${SLOT}.rules || die
		fi
	fi
	rm -fr "${D}"/usr/lib/cups/backend
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

pkg_postinst() {
	if use usb; then
		if [ -x "$(which udevadm)" ]; then
			einfo ""
			einfo "Reloading usb rules..."
			udevadm control --reload-rules 2> /dev/null
			udevadm trigger --action=add --subsystem-match=usb 2> /dev/null
		else
			einfo ""
			einfo "Please, reload usb rules manually."
		fi
	fi	
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
