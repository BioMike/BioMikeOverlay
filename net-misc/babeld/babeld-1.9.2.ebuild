# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Babeld is a routing daemon for a loop-avoiding distance-vector routing protocol"
HOMEPAGE="https://www.irif.univ-paris-diderot.fr/~jch/software/babel/"
SRC_URI="https://github.com/jech/${PN}/archive/${PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${P}"

src_compile() {
	emake || die
}

src_install() {
	dosbin babeld || die
	newman "${S}"/babeld.man babeld.8 || die
	dodoc "${S}"/{README,CHANGES} || die
}
