# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DB_VER="4.8"

LANGS="en is nl"

inherit autotools db-use eutils fdo-mime gnome2-utils kde4-functions qt4-r2

MyPN="Auroracoin"
MyP="${MyPN}-${PV}"

DESCRIPTION="P2P Internet currency Auroracoin"
HOMEPAGE="http://www.auroracoin.is/"
SRC_URI="https://github.com/aurarad/${MyPN}/archive/${PV}.tar.gz -> ${MyP}.tar.gz"

LICENSE="MIT ISC GPL-3 LGPL-2.1 public-domain || ( CC-BY-SA-3.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus kde +qrcode qt upnp"

RDEPEND="
	dev-libs/boost[threads(+)]
	dev-libs/openssl:0[-bindist]
	dev-libs/protobuf:=
	qrcode? (
		media-gfx/qrencode
	)
	upnp? (
		net-libs/miniupnpc
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
	dev-libs/leveldb
	qt? (
		dev-qt/qtgui:4
		dbus? (
			dev-qt/qtdbus:4
		)
	)
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
"

DOCS="doc/README.md doc/release-notes.md"

S="${WORKDIR}/${MyP}"

src_prepare() {
	epatch "${FILESDIR}/3.0.3_sys_leveldb.patch"
	eautoreconf
	rm -r src/leveldb

	cd src || die

	local filt= yeslang= nolang=

	for lan in $LANGS; do
		if [ ! -e qt/locale/bitcoin_$lan.ts ]; then
			ewarn "Language '$lan' no longer supported. Ebuild needs update."
		fi
	done

	for ts in $(ls qt/locale/*.ts)
	do
		x="${ts/*bitcoin_/}"
		x="${x/.ts/}"
		if ! use "linguas_$x"; then
			nolang="$nolang $x"
			#rm "$ts"
			filt="$filt\\|$x"
		else
			yeslang="$yeslang $x"
		fi
	done

	filt="bitcoin_\\(${filt:2}\\)\\.\(qm\|ts\)"
	sed "/${filt}/d" -i 'qt/bitcoin_locale.qrc'
	einfo "Languages -- Enabled:$yeslang -- Disabled:$nolang"
}

src_configure() {
	local my_econf=
	if use upnp; then
		my_econf="${my_econf} --with-miniupnpc --enable-upnp-default"
	else
		my_econf="${my_econf} --without-miniupnpc --disable-upnp-default"
	fi
	econf \
		--enable-wallet \
		--disable-ccache \
		--disable-tests \
		--with-system-leveldb \
		#--with-system-libsecp256k1  \
		--without-daemon  \
        $(use_with qt qt) \
        $(use_with dbus qtdbus)  \
        $(use_with qrcode qrencode)  \
		${my_econf}
}

src_install() {
	default

	insinto /usr/share/pixmaps
	newins "share/pixmaps/bitcoin.ico" "${PN}.ico"

	make_desktop_entry "${PN} %u" "Auroracoin-Qt" "/usr/share/pixmaps/${PN}.ico" "Qt;Network;P2P;Office;Finance;" "MimeType=x-scheme-handler/auroracoin;\nTerminal=false"

	newman contrib/debian/manpages/digibyte-qt.1 ${PN}.1
	newman contrib/debian/manpages/digibyte.conf.5 ${PN}.conf.5

	if use kde; then
		insinto /usr/share/kde4/services
		newins contrib/debian/digibyte-qt.protocol ${PN}.protocol
	fi
}

update_caches() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	buildsycoca
}

pkg_postinst() {
	update_caches
}

pkg_postrm() {
	update_caches
}
