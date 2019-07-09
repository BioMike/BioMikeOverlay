# Copyright 2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )
inherit distutils-r1 git-r3

DESCRIPTION="A python wrapper around the coinmarketcap.com API."
HOMEPAGE="https://github.com/mrsmn/coinmarketcap"
EGIT_REPO_URI="https://github.com/mrsmn/coinmarketcap.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-cache[${PYTHON_USEDEP}]
"
