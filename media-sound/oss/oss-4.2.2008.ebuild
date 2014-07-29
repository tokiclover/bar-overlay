# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/oss/oss-4.2.2008.ebuild,v 1.5 2014/07/28 20:31:48 -tclover Exp $

EAPI=5

inherit eutils flag-o-matic libtool versionator

pv=$(get_version_component_range 1-2)
build=$(get_version_component_range 3)
p="oss-v${pv}-build${build}-src-gpl"

DESCRIPTION="OSSv4 portable, mixing-capable, high quality sound system for Unix"
HOMEPAGE="http://developer.opensound.com/"
SRC_URI="http://www.4front-tech.com/developer/sources/stable/gpl/${p}.tar.bz2"
unset build p pv

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CARDS="ali5455 atiaudio audigyls audioloop audiopci cmi878x cmpci cs4281 \
cs461x digi96 emu10k1x envy24 envy24ht fmedia geode hdaudio ich imux madi \
midiloop midimix sblive sbpci sbxfi solo trident usb userdev via823x via97 ymf7xx"
DEFAULT_CARDS="hdaudio ich imux midiloop midimix"

IUSE="alsa +midi pax_kernel"
for card in ${CARDS}; do
	if has ${card} ${DEFAULT_CARDS} ${OSS_CARDS}; then
		IUSE+=" +oss_cards_${card}"
	else IUSE+=" oss_cards_${card}"; fi
done
REQUIRED_USE="oss_cards_midiloop? ( midi ) oss_cards_midimix? ( midi )"

DEPEND="sys-apps/gawk
	x11-libs/gtk+:2
	>=sys-kernel/linux-headers-2.6.11
	!media-sound/oss-devel"

RDEPEND="${DEPEND}"

src_unpack() {
	default
	mv oss-* ${P} && mkdir build
}

src_prepare() {
	cp "${FILESDIR}"/oss "${S}"/setup/Linux/oss/etc/S89oss
	epatch "${FILESDIR}"/${PN}-${PV}-linux.patch
	use pax_kernel && epatch "${FILESDIR}"/pax_kernel.patch
	elibtoolize
}

src_configure() {
	local drv=osscore
	for card in ${CARDS}; do
		if use oss_cards_${card} || has ${card} ${OSS_CARDS};then
			drv+=,oss_${card}
		fi
	done
	local myconfargs=(
		$(use alsa || echo '--enable-libsalsa=NO')
		$(use midi && echo '--config-midi=YES' || echo '--config-midi=NO')
		--only-drv=$drv
	)
	pushd ../build
	"${S}"/configure "${myconfargs[@]}"
}

src_compile() {
	pushd ../build
	emake build
}

src_install() {
	pushd ../build
	insinto "${D}"
	doins -r prototype/*

	# install a pkgconfig file and make symlink to standard library dir
	newinitd "${FILESDIR}"/oss oss
	local libdir=$(get_libdir)
	insinto /usr/${libdir}/pkgconfig
	doins "${FILESDIR}"/OSSlib.pc
	dosym /usr/${libdir}/{oss/lib/,}libOSSlib.so
	dosym /usr/${libdir}/{oss/lib/,}libossmix.so
	use alsa && dosym /usr/${libdir}/{oss/lib/,}libsalsa.so.2.0.0
	dosym /usr/${libdir}/oss/include /usr/include/oss
}

pkg_postinst() {
	elog ""
	elog "To use ${P} for the first time you must run: \`/etc/init.d/oss start'"
	elog "If you are upgrading, run: \`/etc/init.d/oss restart'"
	elog ""
}
