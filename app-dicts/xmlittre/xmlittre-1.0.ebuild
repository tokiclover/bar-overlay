# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: app-dicts/xmlittre/xmlittre-1.0.ebuild,v 1.1 2012/08/05 10:20:35 Exp $

EAPI=2

inherit stardict

DESCRIPTION="XMLittre (offline version) of E. Littrre's refresh 1872-7 of 1863 Littre's dictionary"
HOMEPAGE="http://francois.gannaz.free.fr/Littre/accueil.php"
SRC_URI="http://francois.gannaz.free.fr/Littre/dlds/XMLittre_stardict_1.0.zip -> ${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=app-text/stardict-2.0"
DEPEND="app-arch/unzip"

S="${WORKDIR}"/${PN/xml/XML}

src_install() {
	dodir/usr/share/stardict/dic
	insinto /usr/share/stardict/dic
	mv {,${PN/xml/XML}.}README
	doins ${PN/xml/XML}.* || die "eek!"
}
