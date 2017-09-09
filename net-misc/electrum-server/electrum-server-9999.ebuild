# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Electrum server"
HOMEPAGE="https://github.com/spesmilo/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/spesmilo/electrum-server.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""

DEPEND="
	${RDEPEND}
	dev-python/irc
	dev-python/jsonrpclib
	dev-python/plyvel
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all
	insinto /etc
	newins electrum.conf.sample electrum.conf
}

pkg_postinst() {
    elog "Don't forget to edit the configuration in /etc/electrum.conf before starting electrum-server."
}


