# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A free software library that interfaces with selected Z-Wave PC controllers on a Z-Wave network."
HOMEPAGE="http://www.openzwave.com/"
SRC_URI="http://old.openzwave.com/downloads/${PN}-${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
    eapply -p2 "${FILESDIR}/${PN}-prefix.patch"
    eapply_user
}


src_install() {
        DESTDIR="${D}" PREFIX="/" emake install
}