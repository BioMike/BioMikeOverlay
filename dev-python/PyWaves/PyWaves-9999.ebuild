# Copyright 2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
inherit distutils-r1 git-r3

DESCRIPTION="Object-oriented library for the Waves blockchain platform."
HOMEPAGE="https://github.com/PyWaves/PyWaves"
EGIT_REPO_URI="https://github.com/PyWaves/PyWaves.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/requests[$PYTHON_USEDEP]
	dev-python/python-axolotl-curve25519[$PYTHON_USEDEP]
	dev-python/pyblake2[$PYTHON_USEDEP]
	dev-python/base58[$PYTHON_USEDEP]
"
