# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $BAR-overlay/media-fonts/sil-nuosu-2.1.1,v 1.1 2011/12/17 -Hypnos Exp $

EAPI=2

inherit font

# see bgo #294941
DESCRIPTION="Nuosu SIL Font is a single Unicode font for the standardized Yi script used by a large ethnic group in southwestern China."
HOMEPAGE="http://scripts.sil.org/SILYi_home"
SRC_URI="http://scripts.sil.org/cms/scripts/render_download.php?site_id=nrsi&format=file&media_id=NuosuSIL2.1.1.zip&filename=NuosuSIL2.1.1.zip -> ${P}.zip"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="FONTLOG.txt OFL.txt OFL-FAQ.txt"
FONT_SUFFIX="ttf"

MY_P="NuosuSIL"
S="${WORKDIR}/${MY_P}"
FONT_S="${S}"
