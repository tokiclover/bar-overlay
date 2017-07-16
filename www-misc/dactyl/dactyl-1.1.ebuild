# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: www-misc/dactyl/dactyl-1.0.ebuild,v 1.2 2015/06/28 Exp $

EAPI=5

case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-2
		EGIT_REPO_URI="git://github.com/5digits/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~x86"
		SRC_URI="https://github.com/5digits/${PN}/archive/penta${P}.tar.gz"
		S="${WORKDIR}/${PN}-penta${P}"
		;;
esac
inherit eutils multilib ${VCS_ECLASS}

DESCRIPTION="Efficient and keyboard friendly vim UI interface add-on"
HOMEPAGE="https://5digits/org https://github.com/5digits/dactyl"

LICENSE="MIT"
SLOT="0"
IUSE="+firefox +plugins songbird thunderbird"
REQUIRED_USE="|| ( firefox songbird thunderbird )"

DEPEND="app-arch/zip
	net-misc/curl
	sys-apps/sed"
RDEPEND="${DEPEND}
	virtual/awk"

DOCS=( BREAKING_CHANGES HACKING )

DACTYL_PLUGINS=(browser-improvements curl fix-focus flashblock http-headers
	jQuery jscompletion noscript useragent xpcom)
for plugin in "${DACTYL_PLUGINS[@]}"; do
SRC_URI="${SRC_URI}
	plugins? ( http://5digits.org/plugins/${plugin}.js -> ${PN}-plugins-${plugin}.js )"
done
unset plugin

src_configure()
{
	BROWSER_SRC=(
		$(usex firefox  'pentadactyl:firefox' '')
		$(usex songbird 'melodactyl:songbird' '')
		$(usex thunderbird 'teledactyl:thunderbird' '')
	)
}

src_compile()
{
	local dir
	for dir in "${BROWSER_SRC[@]}"; do
		pushd "${dir%:*}"
		emake xpi
		popd
	done
}

src_install()
{
	local dir doc{,s} plugin
	for dir in "${BROWSER_SRC[@]}"; do
		insinto /usr/"$(get_libdir)/${dir#*:}"/browser/extensions
		mv downloads/${dir%:*}*.xpi "${dir%:*}@5digits.org.xpi"
		doins "${dir%:*}@5digits.org.xpi"
		for doc in {AUTHORS,NEWS,TODO}; do
			cp ${dir%:*}/${doc} ${doc}.${dir%:*} && docs+=( ${doc}.${dir%:*} )
		done
		dodoc "${docs[@]}"
	done

	if use plugins; then
		dodir /usr/share/${PN}/plugins
		for plugin in "${DACTYL_PLUGINS[@]}"; do
			install -m 644 "${DISTDIR}/${PN}-plugins-${plugin}.js" \
				"${ED}/usr/share/${PN}/plugins/${plugin}.js"
		done
	fi
	dodoc "${DOCS[@]}"
}
