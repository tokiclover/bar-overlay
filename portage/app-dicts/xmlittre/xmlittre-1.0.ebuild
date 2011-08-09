# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit stardict

EAPI="2"

DESCRIPTION="XMLittre offline of E. Littrre's refresh 187i{2,-7} of 1863 dictionary."
HOMEPAGE="http://francois.gannaz.free.fr/Littre/accueil.php"
#SRC_URI="http://francois.gannaz.free.fr/Littre/dlds/XMLittre_stardict_1.0.zip"
SRC_URI="$DISTDIR/$P.tgz"

LICENSE="CC"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="spell"

DEPEND=">=app-text/stardict-2.0"
RDEPEND="${DEPEND}"

src_install() {
	dodir/usr/share/stardict/dic
	insinto /usr/share/stardict/dic
	cd "${WORKDIR}"/*
	mv {,XMLittre.}README 
	doins -r * || die "Failed to install XMLittre dictionary"
}
