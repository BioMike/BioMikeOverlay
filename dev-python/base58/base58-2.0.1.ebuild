# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_6 python3_7 )

inherit python-r1

DESCRIPTION="Base58 and Base58Check implementation compatible with what is used by the bitcoin network."
HOMEPAGE="https://github.com/keis/base58"
SRC_URI="https://github.com/keis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
