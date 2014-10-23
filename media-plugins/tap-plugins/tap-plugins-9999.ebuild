# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-plugins/tap-plugins/tap-plugins-9999.ebuild,v 1.1 2014/10/10 18:00:11 -tclover Exp $

EAPI=5

inherit multilib-minimal git-2

DESCRIPTION="TAP LADSPA plugins: contains DeEsser, Dynamics, Equalizer, Reverb, Stereo Echo, Tremolo"
HOMEPAGE="http://tap-plugins.sf.net"
EGIT_REPO_URI="git://github.com/tomszilagyi/tap-plugins.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/ladspa-sdk[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=( README CREDITS )

src_prepare()
{
	epatch_use
	multilib_copy_sources
}

multilib_src_configure() { :; }
multilib_src_install()
{
	emake install \
		INSTALL_PLUGINS_DIR="${ED}"/usr/$(get_libdir)/ladspa \
		INSTALL_LRDF_DIR="${ED}"/usr/share/ladspa/rdf
}
