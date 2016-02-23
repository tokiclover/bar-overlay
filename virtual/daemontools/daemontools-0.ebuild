# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: virtual/daemontools/daemontools-0.ebuild, 2015/03/30 Exp $

EAPI=5

DESCRIPTION="Virtual for Daemontools Service Manager"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="|| ( sys-process/daemontools sys-process/daemontools-encore
	sys-process/runit sys-apps/s6 )"
