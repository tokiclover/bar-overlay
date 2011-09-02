# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/portage/app-dicts/xmlitrre/xmlittre-1.0.ebuild, v1.1 Exp $

inherit stardict

EAPI="2"

DESCRIPTION="XMLittre (offline version) of E. Littrre's refresh 1872-7 of 1863 Littre's dictionary"
HOMEPAGE="http://francois.gannaz.free.fr/Littre/accueil.php"
SRC_URI="http://francois.gannaz.free.fr/Littre/dlds/XMLittre_stardict_1.0.zip -> ${P}.zip"

LICENSE="CC BY-NC-SA-3.0"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=app-text/stardict-2.0"
DEPEND="app-arch/unzip"

S="${WORKDIR}"/XMLittre

src_install() {
	dodir/usr/share/stardict/dic
	insinto /usr/share/stardict/dic
	mv {,XMLittre.}README
	doins XMLitrre.{dict.dz,idx.gz,ifo,README} || die "eek!"
}
