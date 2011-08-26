# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/poratge/x11-themes/equinox-gtk-theme/equinox-gtk-theme-1.50.ebuild, v1.1 2011/08/26 Exp $

inherit eutils

DESCRIPTION="A collection of gtk themes based on equinox gtk engine"
HOMEPAGE="http://gnome-look.org/content/show.php/Equinox+GTK+Engine"
SRC_URI="http://gnome-look.org/CONTENT/content-files/140448-equinox-themes-1.30.tar.gz -> ${P}.tgz
		rmx? ( http://gnome-look.org/CONTENT/content-files/139207-Equinox%20Remix.tar.gz -> ${PN/gtk/rmx}-1.4.1.tar.gz )"
		# rmx theme home page: http://gnome-look.org/content/show.php/?content=139207

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal rmx"
EAPI=2

RDEPEND="minimal? ( !x11-themes/gnome-theme )
		>=x11-themes/gtk-engines-equinox-1.30"
DEPEND=""

RESTRICT="binchecks strip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_install() {
	for dir in $(ls -d Equinox\ *); do
		local ren=$(echo $dir|sed "s: ::g")
		if [ "$dir" != "$ren" ]; then
			mv $(echo $dir|sed "s: :\ :g") $ren || die "eek!"
		fi
	done
	mv userChrome.css Equinox/
	insinto /usr/share/themes
	doins -r ./Equinox{,Classic{,Glass},Evolution{,.crx,Light,Rounded,Squared},Glass,Light{,Glass},Wide} || die "eek!"
	use rmx && doins -r ./EquinoxRemix || die "eek!"
}

