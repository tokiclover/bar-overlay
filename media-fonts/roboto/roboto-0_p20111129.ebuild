# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-fonts/roboto/roboto-0_p20111129.ebuild,v 1.1 2011/12/17 -tclover Exp $

EAPI=2

inherit font

MY_P=Roboto_Hinted_${PV#*_p}

DESCRIPTION="Font family from Google's Android project"
HOMEPAGE="https://developer.android.com/design/style/typography.html"
SRC_URI="https://dl-ssl.google.com/android/design/${MY_P}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="NOTICE.txt"
FONT_SUFFIX="ttf"

S="${WORKDIR}/${MY_P}"
FONT_S="${S}"
