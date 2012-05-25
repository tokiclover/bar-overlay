# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-3.20-r4.ebuild,v 1.1 2012/05/25 15:10:50 -tclover Exp $

# see bgo #130645

EAPI=4

inherit eutils rpm flag-o-matic multilib

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
HOMEPAGE="http://support-asia.canon-asia.com/content/EN/0100084101.html"
RESTRICT="nomirror confcache"

SRC_URI="http://gdlp01.c-wss.com/gds/7/0100002367/01/cnijfilter-source-3.20-1.tar.gz"
LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

SLOT="3.20"
KEYWORDS="~x86 ~amd64"
IUSE="amd64
	servicetools
	nocupsdetection
	mp250
	mp270
	mp490
	mp550
	mp560
	ip4700
	mp640
"
REQUIRED_USE="amd64? ( !servicetools )"
DEPEND="app-text/ghostscript-gpl
	>=net-print/cups-1.1.14
	!amd64? ( sys-libs/glibc
		>=dev-libs/popt-1.6
		>=media-libs/tiff-3.4
		>=media-libs/libpng-1.0.9 )
	amd64? ( >=app-emulation/emul-linux-x86-bjdeps-0.1
		app-emulation/emul-linux-x86-compat
		app-emulation/emul-linux-x86-baselibs )
	servicetools? ( 
		!amd64? ( >=gnome-base/libglade-0.6
			>=dev-libs/libxml2-2.7.3-r2
			=x11-libs/gtk+-1.2* )
		amd64? ( >=app-emulation/emul-linux-x86-bjdeps-0.1
			app-emulation/emul-linux-x86-gtklibs )
	)
"

S="${WORKDIR}"/${PN}-source-${PV}-1

# Arrays of supported Printers, there IDs and compatible models
_pruse=("mp250" "mp270" "mp490" "mp550" "mp560" "ip4700" "mp640")
_prname=(${_pruse[@]})
_prid=("356" "357" "358" "359" "360" "361" "362")
_prcomp=("mp250series" "mp270series" "mp490series" "mp550series" "mp560series" "ip4700series" "mp640series")
_max=$((${#_pruse[@]}-1)) # used for iterating through these arrays

pkg_setup() {

	if [ -z "$LINGUAS" ]; then
		ewarn "You didn't specify 'LINGUAS' in your make.conf. Assuming"
		ewarn "english localisation, i.e. 'LINGUAS=\"en\"'."
		LINGUAS="en"
	fi

#	use amd64 && append-flags -L/emul/linux/x86/lib -L/emul/linux/x86/usr/lib -L/usr/lib32 
	use amd64 && multilib_toolchain_setup x86

	
	_bindir="/usr/bin"
	_libdir="/usr/$(get_libdir)"
	_cupsdir1="/usr/lib/cups"
	_cupsdir2="/usr/libexec/cups"
	_ppddir="/usr/share/cups/model"

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
		einfo "As example:\tbasic MP140 support without maintenance tools"
		einfo "\t\t -> USE=\"mp140\""
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
	epatch ${FILESDIR}/${P%*-r}-4-cups_ppd.patch || die
	epatch ${FILESDIR}/${P%*-r}-4-ldl.patch || die
	epatch ${FILESDIR}/${P%*-r}-4-libpng15.patch || die
}

src_configure() {
	cd libs || die
	./autogen.sh --prefix=/usr || die "Error: libs/autoconf.sh failed"
	make || die "Couldn't make libs"

	cd ../backend || die
	./autogen.sh --prefix=/usr --enable-progpath=${_bindir} || die "Error: backend/autoconf.sh failed"
	make || die "Couldn't make backend"

	cd ../pstocanonij || die
	./autogen.sh --prefix=/usr --enable-progpath=${_bindir} || die "Error: pstocanonij/autoconf.sh failed"
	make || die "Couldn't make pstocanonij"

	if use servicetools; then
		cd ../cngpij || die
		./autogen.sh --prefix=/usr --enable-progpath=${_bindir} || die "Error: cngpij/autoconf.sh failed"
		make || die "Couldn't make cngpij"

		cd ../cngpijmon || die
		./autogen.sh --prefix=/usr || die "Error: cngpijmon/autoconf.sh failed"
		make || die "Couldn't make cngpijmon"
	fi
}

src_compile() {
	for i in `seq 0 ${_max}`; do
		if use ${_pruse[$i]} || ${_autochoose}; then
			_pr=${_prname[$i]} _prid=${_prid[$i]}
			src_compile_pr
		fi
	done
}

src_install() {
	mkdir -p "${D}${_bindir}" || die
	mkdir -p "${D}${_libdir}"/cups/filter || die
	mkdir -p "${D}${_ppddir}" || die
	mkdir -p "${D}${_libdir}"/cnijlib || die

	cd libs || die
	make DESTDIR="${D}" install || die "Couldn't make install libs"

	cd ../backend || die
	make DESTDIR="${D}" install || die "Couldn't make install backend"

	cd ../pstocanonij || die
	make DESTDIR="${D}" install || die "Couldn't make install pstocanoncnij"

	if use servicetools; then
		cd ../cngpij || die
		make DESTDIR="${D}" install || die "Couldn't make install cngpij"

		cd ../cngpijmon || die
		make DESTDIR="${D}" install || die "Couldn't make install cngpijmon"
	fi

	cd ..

	for i in `seq 0 ${_max}`; do
		if use ${_pruse[$i]} || ${_autochoose}; then
			_pr=${_prname[$i]} _prid=${_prid[$i]}
			src_install_pr;
		fi
	done

	# fix directory structure
	mkdir -p "${D}${_cupsdir2}"/filter || die
	mv "${D}${_cupsdir1}"/filter/pstocanonij \
		"${D}${_cupsdir2}/filter/pstocanonij${SLOT}" || die
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

# Custom Helper Functions

src_compile_pr()
{
	mkdir ${_pr}
	cp -a ${_prid} ${_pr} || die
	cp -a cnijfilter ${_pr} || die
	cp -a printui ${_pr} || die
	cp -a lgmon ${_pr} || die
#	cp -a stsmon ${_pr} || die

	sleep 10
	cd ${_pr}/cnijfilter || die
	./autogen.sh --prefix=/usr --program-suffix=${_pr} --enable-libpath=${_libdir}/cnijlib --enable-binpath=${_bindir} || die
	make || die "Couldn't make ${_pr}/cnijfilter"

	if use servicetools; then
		cd ../printui || die
		./autogen.sh --prefix=/usr --program-suffix=${_pr} || die
		make || die "Couldn't make ${_pr}/printui"

		cd ../lgmon || die
		./autogen.sh --program-suffix=${_pr} || die
		make || die "Couldn't make ${_pr}/lgmon"

#		cd ../stsmon || die
#		./autogen.sh --prefix=/usr --program-suffix=${_pr} --enable-progpath=${_bindir} || die
#		make || die "Couldn't make ${_pr}/stsmon"
	fi

	cd ../..
}

src_install_pr()
{
	cd ${_pr}/cnijfilter || die
	make DESTDIR="${D}" install || die "Couldn't make install ${_pr}/cnijfilter"

	if use servicetools; then
		cd ../printui || die
		make DESTDIR="${D}" install || die "Couldn't make install ${_pr}/printui"

		cd ../lgmon || die
		make DESTDIR="${D}" install || die "Couldn't make install ${_pr}/lgmon"

#		cd ../stsmon || die
#		make DESTDIR=${D} install || die "Couldn't make install ${_pr}/stsmon"
	fi

	cd ../..
	cp -a ${_prid}/libs_bin/* "${D}${_libdir}" || die
	cp -a ${_prid}/database/* "${D}${_libdir}"/cnijlib || die
	cp -a ppd/canon${_pr}.ppd "${D}${_ppddir}" || die
}

