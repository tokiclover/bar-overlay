# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-misc/connman/connman-9999.ebuild,v 1.4 2014/07/07 20:54:56 -tclover Exp $

EAPI=5

inherit multilib git-2 autotools

DESCRIPTION="Provides a daemon for managing internet connections"
HOMEPAGE="http://connman.net"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/network/connman/connman.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="bluetooth debug doc examples +ethernet gnutls networkmanager ofono
openconnect openvpn policykit selinux threads tools vpnc +wifi wimax"
REQUIRED_USE="selinux? ( openvpn )"

RDEPEND=">=dev-libs/glib-2.18
	>=sys-apps/dbus-1.4
	sys-libs/readline
	>=dev-libs/libnl-1.1
	>=net-firewall/iptables-1.4.11
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

src_prepare() {
	eautoreconf
}

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
