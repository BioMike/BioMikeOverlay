# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Spherical mercator tile and coordinate utilities"
HOMEPAGE="https://github.com/mapbox/mercantile"
SRC_URI="https://github.com/mapbox/mercantile/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

#RDEPEND="
#	dev-python/click[${PYTHON_USEDEP}]"