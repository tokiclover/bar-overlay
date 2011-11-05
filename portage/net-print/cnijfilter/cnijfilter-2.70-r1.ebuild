# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/net-print/cnijfilter-2.70-r1,v 1.1 2011/11/05 -tclover Exp $

# Changelog since last bugzilla upload
#
# initial version
#

inherit eutils rpm flag-o-matic multilib

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
DOWNLOAD_URL="http://software.canon-europe.com/software/0027403.asp"
SRC_URI="${DISTDIR}/${PN}-common-${PV}-2.src.rpm"
RESTRICT="fetch nomirror confcache"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE="amd64
	servicetools
	nocupsdetection
	mp160
	mp510
	mp600
	ip90
	ip1800
	ip2500
	ip3300
	ip4300"
DEPEND="app-text/ghostscript-gpl
	>=net-print/cups-1.1.14
	!amd64? ( sys-libs/glibc
		>=dev-libs/popt-1.6
		>=media-libs/tiff-3.4
		>=media-libs/libpng-1.0.9 )
	amd64? ( >=app-emulation/emul-linux-x86-bjdeps-0.1
		app-emulation/emul-linux-x86-compat
		app-emulation/emul-linux-x86-baselibs )
	servicetools? ( !amd64? ( >=gnome-base/libglade-0.6
			>=dev-libs/libxml-1.8
			=x11-libs/gtk+-1.2* )
		amd64? ( >=app-emulation/emul-linux-x86-bjdeps-0.1
			app-emulation/emul-linux-x86-gtklibs ) )"
# >=automake-1.6.3

# Arrays of supported Printers, there IDs and compatible models
_pruse=("mp160" "ip3300" "mp510" "ip4300" "mp600" "ip2500" "ip1800" "ip90")
_prname=(${_pruse[@]})
_prid=("291" "292" "293" "294" "295" "311" "312" "253")
_prcomp=("mp160" "ip3300" "mp510" "ip4300" "mp600" "ip2500series" "ip1800series" "ip90")
_max=$((${#_pruse[@]}-1)) # used for iterating through these arrays

###
#   Standard Ebuild-functions
###

pkg_nofetch() {
	einfo "Please download ${SRC_URI} manually from"
	einfo ${DOWNLOAD_URL}
	einfo "and move it to ${DISTDIR}"
}

pkg_setup() {
	if [ -z "$LINGUAS" ]; then    # -z tests to see if the argument is empty
		ewarn "You didn't specify 'LINGUAS' in your make.conf. Assuming"
		ewarn "english localisation, i.e. 'LINGUAS=\"en\"'."
		LINGUAS="en"
	fi
	if (use amd64 && use servicetools); then
		eerror "You can't build this package with 'servicetools' on amd64,"
		eerror "because you would need to compile '>=gnome-base/libglade-0.6'"
		eerror "and '>=dev-libs/libxml-1.8' with 'export ABI=x86' first."
		eerror "That's exactly what 'emul-linux-x86-bjdeps-0.1' does with"
		eerror "'dev-libs/popt-1.6'. I encourage you to adapt this ebuild"
		eerror "to build 32bit versions of 'libxml' and 'libglade' too!"
		die "servicetools not yet available on amd64"
	fi

	use amd64 && export ABI=x86
	use amd64 && append-flags -L/emul/linux/x86/lib -L/emul/linux/x86/usr/lib -L/usr/lib32 
	
	_prefix="/usr/local"
	_bindir="/usr/local/bin"
	_libdir="/usr/$(get_libdir)" # either lib or lib32
	_cupsdir1="/usr/lib/cups"
	_cupsdir2="/usr/libexec/cups"
	_ppddir="/usr/share/cups/model"

	einfo ""
	einfo " USE-flags       (description / probably compatible printers)"
	einfo ""
	einfo " amd64           (basic support for this architecture - currently without servicetools)"
	einfo " servicetools    (additional monitoring and maintenance software)"
	einfo " nocupsdetection (this is only useful to create binary packages)"
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

src_unpack() {
	rpm_src_unpack || die
	mv ${PN}-common-${PV} ${P} || die # Correcting directory-structure
}

src_compile() {
	cd libs || die
	./autogen.sh --prefix=${_prefix} || die "Error: libs/autoconf.sh failed"
	make || die "Couldn't make libs"

	cd ../pstocanonij || die
	./autogen.sh --prefix=/usr --enable-progpath=${_bindir} || die "Error: pstocanonij/autoconf.sh failed"
	make || die "Couldn't make pstocanonij"

	if use servicetools; then
		cd ../cngpij || die
		./autogen.sh --prefix=${_prefix} --enable-progpath=${_bindir} || die "Error: cngpij/autoconf.sh failed"
		make || die "Couldn't make cngpij"

		cd ../cngpijmon || die
		./autogen.sh --prefix=${_prefix} || die "Error: cngpijmon/autoconf.sh failed"
		make || die "Couldn't make cngpijmon"
	fi

	cd ..

	for i in `seq 0 ${_max}`; do
		if use ${_pruse[$i]} || ${_autochoose}; then
			_pr=${_prname[$i]} _prid=${_prid[$i]}
			src_compile_pr;
		fi
	done
}

src_install() {
	mkdir -p ${D}${_bindir} || die
	mkdir -p ${D}${_libdir}/cups/filter || die
	mkdir -p ${D}${_ppddir} || die
	mkdir -p ${D}${_libdir}/cnijlib || die

	cd libs || die
	make DESTDIR=${D} install || die "Couldn't make install libs"

	cd ../pstocanonij || die
	make DESTDIR=${D} install || die "Couldn't make install pstocanoncnij"

	if use servicetools; then
		cd ../cngpij || die
		make DESTDIR=${D} install || die "Couldn't make install cngpij"

		cd ../cngpijmon || die
		make DESTDIR=${D} install || die "Couldn't make install cngpijmon"
	fi

	cd ..

	for i in `seq 0 ${_max}`; do
		if use ${_pruse[$i]} || ${_autochoose}; then
			_pr=${_prname[$i]} _prid=${_prid[$i]}
			src_install_pr;
		fi
	done

	# fix directory structure
	if use nocupsdetection; then
		mkdir -p ${D}${_cupsdir2}/filter || die
		dosym ${_cupsdir1}/filter/pstocanonij ${_cupsdir2}/filter/pstocanonij
	elif has_version ">=net-print/cups-1.2.0"; then
		mkdir -p ${D}${_cupsdir2} || die
		mv ${D}${_cupsdir1}/* ${D}${_cupsdir2} || die
	fi
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
	einfo ""
}

###
#	Custom Helper Functions
###

src_compile_pr()
{
	mkdir ${_pr}
	cp -a ${_prid} ${_pr} || die
	cp -a cnijfilter ${_pr} || die
	cp -a printui ${_pr} || die
#	cp -a stsmon ${_pr} || die

	sleep 10
	cd ${_pr}/cnijfilter || die
	./autogen.sh --prefix=${_prefix} --program-suffix=${_pr} --enable-libpath=${_libdir}/cnijlib --enable-binpath=${_bindir} || die
	make || die "Couldn't make ${_pr}/cnijfilter"

	if use servicetools; then
		cd ../printui || die
		./autogen.sh --prefix=${_prefix} --program-suffix=${_pr} || die
		make || die "Couldn't make ${_pr}/printui"

#		cd ../stsmon || die
#		./autogen.sh --prefix=${_prefix} --program-suffix=${_pr} --enable-progpath=${_bindir} || die
#		make || die "Couldn't make ${_pr}/stsmon"
	fi

	cd ../..
}

src_install_pr()
{
	cd ${_pr}/cnijfilter || die
	make DESTDIR=${D} install || die "Couldn't make install ${_pr}/cnijfilter"

	if use servicetools; then
		cd ../printui || die
		make DESTDIR=${D} install || die "Couldn't make install ${_pr}/printui"

#		cd ../stsmon || die
#		make DESTDIR=${D} install || die "Couldn't make install ${_pr}/stsmon"
	fi

	cd ../..
	cp -a ${_prid}/libs_bin/* ${D}${_libdir} || die
	cp -a ${_prid}/database/* ${D}${_libdir}/cnijlib || die
	cp -a ppd/canon${_pr}.ppd ${D}${_ppddir} || die
}

