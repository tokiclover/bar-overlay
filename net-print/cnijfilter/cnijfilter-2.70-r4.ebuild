# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-print/cnijfilter/cnijfilter-2.70-r4.ebuild,v 1.6 2012/06/01 13:22:55 -tclover Exp $

EAPI=4

inherit eutils autotools rpm flag-o-matic

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)."
DOWNLOAD_URL="http://software.canon-europe.com/software/0027403.asp"
SRC_URI="${PN}-common-${PV}-2.src.rpm"
RESTRICT="fetch"

LICENSE="UNKNOWN" # GPL-2 source and proprietary binaries

KEYWORDS="~x86 ~amd64"
IUSE="amd64 +debug gtk multislot nls servicetools usb"
SLOT=${PV}
REQUIRED_USE="servicetools? ( gtk ) nls? ( gtk ) usb? ( gtk )"
[ "${ARCH}" == "amd64" ] && REQUIRED_USE+=" servicetools? ( amd64 )"
PRUSE=("mp160" "ip3300" "mp510" "ip4300" "mp600" "ip2500" "ip1800" "ip90")
PRID=("291" "292" "293" "294" "295" "311" "312" "253")
IUSE+=" ${PRUSE[@]}"
S="${WORKDIR}"/${PN}-common-${PV}

DEPEND="app-text/ghostscript-gpl
	>=net-print/cups-1.1.14
	sys-libs/glibc
	nls? ( >=sys-devel/gettext-0.10.38 )
	servicetools? ( 
		>=gnome-base/libglade-0.6
		>=dev-libs/libxml-1.8 )
	amd64? (
		gtk? ( app-emulation/emul-linux-x86-gtklibs )
		app-emulation/emul-linux-x86-popt
		app-emulation/emul-linux-x86-compat
		app-emulation/emul-linux-x86-baselibs )
	!amd64? (
		gtk? ( x11-libs/gtk+:2 )
		>=dev-libs/popt-1.6
		>=media-libs/tiff-3.4
		>=media-libs/libpng-1.0.9 )
"

pkg_nofetch() {
	einfo "Please download ${SRC_URI} manually from"
	einfo "${DOWNLOAD_URL} and extract it from that"
	einfo "and move it to ${DISTDIR}"
}

pkg_setup() {
	use amd64 && multilib_toolchain_setup x86
	use gtk && SRC+=" cngpijmon" PRSRC+=" lgmon"
	use servicetools && PRSRC+=" printui"

	PRN="$(seq 0 $((${#PRUSE[@]}-1)))"
	if [[ -z "${PRCOM}" ]]; then declare -a PRCOM
		for p in ${PRN}; do
			PRCOM[p]="${PRUSE[$p]}series"
		done
	fi

	local ac="true"
	for p in ${PRN}; do
		einfo " ${PRUSE[$p]}\t${PRCOM[$p]}"
		if (use ${PRUSE[$p]}); then
			ac="false"
		fi
	done
	if ${ac}; then
		einfo ""
		ewarn "You didn't specify any printer model (USE flag)"
		einfo "to get ${PRUSE[1]} support, for example, USE=\"${PRUSE[1]}\""
		einfo ""
		die
	fi
}

src_prepare() {
	sed -e 's/-lxml/-lxml2/g' -i cngpijmon/src/Makefile.am -i printui/src/Makefile.am
	epatch "${FILESDIR}"/${P%-r*}-4-cups_ppd.patch
	epatch "${FILESDIR}"/${P%-r*}-1-png_jmpbuf-fix.patch || die

	for dir in libs cngpij ${SRC} pstocanonij; do
		pushd ${dir} || die
		[ -d configures ] && mv -f configures/configure.in.new configure.in
		use nls && [ -d po ] && echo "no" | glib-gettextize --copy --force
		autotools_run_tool libtoolize --automake --copy --force
		eaclocal
		eautoheader
		eautomake --gnu
		eautoreconf
		popd
	done

	local p pr prid
	for p in ${PRN}; do
		pr=${PRUSE[$p]} prid=${PRID[$p]}
		if use ${pr}; then
			mkdir ${pr} || die
			for dir in ${prid} cnijfilter ${PRSRC}; do
				cp -a ${dir} ${pr} || die
			done
			pushd ${pr} || die
			src_prepare_pr
			popd
		fi
	done
}

src_configure() {
	for dir in libs cngpij ${SRC} pstocanonij; do
		pushd ${dir} || die
		econf
		popd
	done

	local p pr prid
	mv {,_}lgmon || die
	for p in ${PRN}; do
		pr=${PRUSE[$p]} prid=${PRID[$p]}
		if use ${pr}; then
			ln -sf ${pr}/lgmon lgmon
			pushd ${pr} || die
			src_configure_pr
			popd
		fi
	done
}

src_compile() {
	local p pr prid
	for p in ${PRN}; do
		pr=${PRUSE[$p]} prid=${PRID[$p]}
		if use ${pr}; then
			pushd ${pr} || die
			src_compile_pr
			popd
		fi
	done

	for dir in libs cngpij ${SRC} pstocanonij; do
		pushd ${dir} || die
		emake || die
		popd
	done
}

src_install() {
	local p pr prid ldir=/usr/$(get_libdir) le=/usr/libexec/cups/ bindir=/usr/bin 
	local bdir=${le}backend fdir=${le}filter odir=${ldir}/cups/filter slot
	use multislot && slot=${SLOT} || slot=${SLOT:0:1}
	mkdir -p "${D}"{${ldir}/bjlib,${bdir},${fdir}}

	for dir in libs cngpij ${SRC} pstocanonij; do
		pushd ${dir} || die
		emake DESTDIR="${D}" install || die
		popd
	done

	for p in ${PRN}; do
		pr=${PRUSE[$p]} prid=${PRID[$p]}
		if use ${pr}; then
			pushd ${pr} || die
			src_install_pr
			popd

			cp -a ${prid}/libs_bin/* "${D}${ldir}" || die
			install -m644 ${prid}/database/* "${D}${ldir}"/bjlib || die
			sed -e "s/pstocanonij/pstocanonij${slot}/g" -i ppd/canon${pr}.ppd || die
			install -Dm644 ppd/canon${pr}.ppd "${D}${pdir}"/${pr}.ppd || die
		fi
	done

	if use usb; then
		mv "${D}${odir}"/cnij*usb "${D}${bdir}"/cnijusb${slot} || die
	fi
	mv "${D}${odir}"/pstocanonij "${D}${fdir}/pstocanonij${slot}" || die
	mv "${D}${bindir}"/cngpij{,${slot}} || die
	rm -fr "${D}${ldir}"/cups
}

src_prepare_pr() {
	for dir in cnijfilter ${PRSRC}; do
		pushd ${dir} || die
		[ -d configures ] && mv -f configures/configure.in.new configure.in
		use nls && [ -d po ] && echo "no" | glib-gettextize --copy --force
		autotools_run_tool libtoolize --automake --copy --force
		eaclocal
		eautoheader
		eautomake --gnu
		eautoreconf
		popd
	done
}

src_configure_pr() {
	for dir in cnijfilter ${PRSRC}; do
		pushd ${dir} || die
		econf --program-suffix=${pr}
		popd
	done
}

src_compile_pr() {
	for dir in cnijfilter ${PRSRC}; do
		pushd ${dir} || die
		emake || die "${dir}: emake failed"
		popd
	done
}

src_install_pr() {
	for dir in cnijfilter ${PRSRC}; do
		pushd ${dir} || die
		emake DESTDIR="${D}" install || die "${dir}: emake install failed"
		popd
	done
}

pkg_postinst() {
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
