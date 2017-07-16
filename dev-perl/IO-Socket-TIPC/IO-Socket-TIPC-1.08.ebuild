# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: dev-perl/IO-Socket-TIPC/IO-Socket-TIPC-1.08.ebuild,v 1.0 2015/01/26 Exp $

EAPI=5

MODULE_AUTHOR=INFINOID
inherit perl-module

DESCRIPTION="IO::Socket::TIPC - TIPC sockets for Perl"

LICENSE="|| ( BSD-2 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

SRC_TEST="do"
