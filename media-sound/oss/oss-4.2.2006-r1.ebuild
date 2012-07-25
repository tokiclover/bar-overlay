# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-sound/oss/oss-4.2.2006.ebuild,v 1.3 2012/07/25 22:34:14 -tclover Exp $

EAPI=4

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

SOUND_CARDS="ali4555 atiaudio audigyls audioloop audiopci cmi878x cmpci cs4281
cs461x digi96 emu10k1x envy24 envy24ht fmedia geode hdaudio ich imux madi
midiloop midimix sblive sbpci sbxfi solo trident usb userdev via823x via97 ymf7xx"
for card in ${SOUND_CARDS}; do
	IUSE_OSS_CARDS+=" oss_cards_${card}"
done

IUSE="${IUSE_OSS_CARDS} +midi"
REQUIRED_USE="oss_cards_midiloop? ( midi ) oss_cards_midimix? ( midi )"

DEPEND="sys-apps/gawk
	x11-libs/gtk+:2
	>=sys-kernel/linux-headers-2.6.11
	!media-sound/oss-devel"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${A}"
	mv oss-* ${P} && mkdir build
}

src_prepare() {
	cp "${FILESDIR}"/oss "${S}"/setup/Linux/oss/etc/S89oss
	epatch "${FILESDIR}"/${PN}-${PV}-{afmt-float,freebsd-fix,hdaudio-dev}.patch
	elibtoolize
}

src_configure() {
	local conf="--enable-timings \
		$(use midi && echo '--config-midi=YES' || echo '--config-midi=NO') \
		--only-drv=osscore"
	for card in ${SOUND_CARDS}; do
		use oss_cards_${card} || has ${card} ${OSS_CARDS:-hdaudio} &&
			conf+=,oss_${card}
	done
	cd ../build
	"${S}"/configure ${conf} || die "configure failed"
	sed -i -e 's/-D_KERNEL//' -i Makefile
}

src_compile() {
	cd ../build
	emake build || die "emake build failed"
}

src_install() {
	newinitd "${FILESDIR}"/oss oss
	cd ../build
	cp -R prototype/* "${D}"
}

pkg_postinst() {
	elog "To use ${P} for the first time you must run"
	elog "# /etc/init.d/oss start "
	elog ""
	elog "If you are upgrading, run"
	elog "# /etc/init.d/oss restart "
	elog ""
	elog "Enjoy OSSv4!"
}
