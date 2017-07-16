# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: net-misc/tipcutils/tipcutils-2.0.3.ebuild,v 1.4 2015/01/26 22:21:54 Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Utilities for TIPC (Transparent Inter-Process Communication)"
HOMEPAGE="http://tipc.sourceforge.net"
SRC_URI="mirror://sourceforge/tipc/${P}.tar.gz"

LICENSE="|| ( BSD-2 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=sys-kernel/linux-headers-2.6.39"

DOCS=( README )
