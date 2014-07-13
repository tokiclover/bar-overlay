# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/net-misc/connman/connman-1.24.ebuild,v 1.4 2014/07/07 20:54:56 -tclover Exp $

EAPI=5

inherit base

DESCRIPTION="Provides a daemon for managing internet connections"
HOMEPAGE="http://connman.net"
SRC_URI="mirror://kernel/linux/network/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="bluetooth debug doc examples +ethernet gnutls networkmanager ofono
openconnect openvpn policykit selinux threads tools vpnc +wifi wimax"
REQUIRED_USE="selinux? ( openvpn )"

RDEPEND=">=dev-libs/glib-2.16
	>=sys-apps/dbus-1.2.24
	sys-libs/readline
	>=dev-libs/libnl-1.1
	>=net-firewall/iptables-1.4.8
	gnutls? ( net-libs/gnutls )
	bluetooth? ( net-wireless/bluez )
	ofono? ( net-misc/ofono )
	policykit? ( sys-auth/polkit )
	openconnect? ( net-misc/openconnect[gnutls?] )
	openvpn? ( net-misc/openvpn )
	selinux? ( sec-policy/selinux-openvpn )
	vpnc? ( net-misc/vpnc )
	wifi? ( >=net-wireless/wpa_supplicant-0.7[dbus] )
	wimax? ( net-wireless/wimax )"

DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.39"

src_configure() {
	econf \
		--localstatedir=/var \
		--enable-client \
		--enable-datafiles \
		--enable-loopback=builtin \
		$(use_enable examples test) \
		$(use_enable ethernet ethernet builtin) \
		$(use_enable wifi wifi builtin) \
		$(use_enable bluetooth bluetooth builtin) \
		$(use_enable networkmanager nmcompat) \
		$(use_enable ofono ofono builtin) \
		$(use_enable openconnect openconnect builtin) \
		$(use_enable openvpn openvpn builtin) \
		$(use_enable policykit polkit builtin) \
		$(use_enable selinux) \
		$(use_enable vpnc vpnc builtin) \
		$(use_enable wimax iwmx builtin) \
		$(use_enable debug) \
		$(use_enable threads) \
		$(use_enable tools) \
		--disable-iospm \
		--disable-hh2serial-gps \
		--disable-pacrunner
}

src_install() {
	emake DESTDIR="${D}" install
	dobin client/connmanctl
	doman doc/{connman.8,connman.conf.5,connmanctl.1}
	use doc && dodoc doc/*.txt

	keepdir /var/lib/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
