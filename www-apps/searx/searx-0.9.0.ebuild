# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: www-apps/searx/searx-9999.ebuild,v 1.2 2016/06/06 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/asciimoo/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="https://github.com/asciimoo/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac
inherit eutils user distutils-r1 ${VCS_ECLASS}

DESCRIPTION="Decentralized and privacy-respecting, hackable metasearch engine"
HOMEPAGE="https://github.com/asciimoo/searx https://searx.me"

LICENSE="AGPL-3"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=">=dev-python/flask-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/flask-babel-0.9[${PYTHON_USEDEP}]
	>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.11[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.4.2[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.15.1[${PYTHON_USEDEP}]
	>=dev-python/ndg-httpsclient-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.0.8[${PYTHON_USEDEP}]
	>=dev-python/certifi-2015.11.20[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS.rst CHANGELOG.rst README.rst )

src_prepare()
{
	sed -e "s/ultrasecretkey/$(openssl rand -hex 16)/g" -i searx/settings.yml || die
	distutils-r1_src_prepare
}

pkg_postinst()
{
	echo
	elog "Run \`searx-run' as an un-priviledged user; and then"
	elog "go to http://localhost:8888 for the local search engine."
	echo
}
