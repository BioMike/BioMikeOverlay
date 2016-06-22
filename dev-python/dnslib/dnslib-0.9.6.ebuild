# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
inherit distutils-r1

DESCRIPTION="A simple library to encode/decode DNS wire-format packets."
HOMEPAGE="https://bitbucket.org/paulc/dnslib"
SRC_URI="https://bitbucket.org/paulc/dnslib/get/${PV}.tar.bz2 -> ${P}.tar.bz2"


MY_P="paulc-${PN}-c6871d81b4f8"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
