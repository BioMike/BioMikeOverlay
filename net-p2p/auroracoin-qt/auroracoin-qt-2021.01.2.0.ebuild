# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DB_VER="5.3"
inherit autotools bash-completion-r1 db-use desktop xdg-utils

MyPN="Auroracoin"
MyP="${MyPN}-${PV}"

DESCRIPTION="An end-user Qt GUI for the Auroracoin crypto-currency"
HOMEPAGE="https://auroracoin.is/"
SRC_URI="https://github.com/aurarad/${MyPN}/archive/${PV}.tar.gz -> ${MyP}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

IUSE="+asm dbus kde +qrcode +system-leveldb test upnp +wallet zeromq"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/boost-1.52.0:=[threads(+)]
	>dev-libs/libsecp256k1-0.1_pre20170321:=[recovery]
	>=dev-libs/univalue-1.0.4:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	system-leveldb? ( virtual/bitcoin-leveldb )
	dbus? ( dev-qt/qtdbus:5 )
	dev-libs/libevent:=
	qrcode? (
		media-gfx/qrencode:=
	)
	upnp? ( >=net-libs/miniupnpc-1.9.20150916:= )
	wallet? ( sys-libs/db:$(db_ver_to_slot "${DB_VER}")=[cxx] )
	zeromq? ( net-libs/zeromq:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/autoconf-2.69
	>=sys-devel/automake-1.13
	dev-qt/linguist-tools:5
"

S="${WORKDIR}/${MyP}"

DOCS=(
	doc/bips.md
	doc/auroracoin-conf.md
	doc/descriptors.md
	doc/files.md
	doc/JSON-RPC-interface.md
	doc/psbt.md
	doc/reduce-traffic.md
	doc/release-notes.md
	doc/REST-interface.md
	doc/tor.md
)

pkg_pretend() {
	elog "Replace By Fee policy is now always enabled by default: Your node will"
	elog "preferentially mine and relay transactions paying the highest fee, regardless"
	elog "of receive order. To disable RBF, set mempoolreplacement=never in auroracoin.conf"
}

src_prepare() {
	#@sed -i 's/^\(complete -F _auroracoind \)auroracoind \(auroracoin-qt\)$/\1\2/' contrib/auroracoind.bash-completion || die

	# Save the generic icon for later
	#cp src/qt/res/src/auroracoin.svg auroracoin128.svg || die

	eapply "${FILESDIR}/2021.01.2.0_system_leveldb.patch"

	eapply_user

	echo '#!/bin/true' >share/genbuild.sh || die
	mkdir -p src/obj || die
	echo "#define BUILD_SUFFIX gentoo${PVR#${PV}}" >src/obj/build.h || die

	eautoreconf
	#rm -r src/secp256k1 || die
	if use system-leveldb; then
		rm -r src/leveldb || die
	fi
}

src_configure() {
	local my_econf=(
		$(use_enable asm)
		$(use_with dbus qtdbus)
		$(use_with qrcode qrencode)
		$(use_with upnp miniupnpc)
		$(use_enable upnp upnp-default)
		$(use_enable test tests)
		$(use_enable wallet)
		$(use_enable zeromq zmq)
		--with-gui=qt5
		--disable-util-cli
		--disable-util-tx
		--disable-util-wallet
		--disable-bench
		--without-libs
		--without-daemon
		--disable-fuzz
		--disable-ccache
		--disable-static
		$(use_with system-leveldb)
		--with-system-libsecp256k1
		--with-system-univalue
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	rm -f "${ED}/usr/bin/test_auroracoin" || die

	#insinto /usr/share/icons/hicolor/scalable/apps/
	#doins auroracoin128.svg

	cp "${FILESDIR}/org.auroracoin.auroracoin-qt.desktop" "${T}" || die
	domenu "${T}/org.auroracoin.auroracoin-qt.desktop"

	use zeromq && dodoc doc/zmq.md

	#newbashcomp contrib/auroracoind.bash-completion ${PN}

	if use kde; then
		insinto /usr/share/kservices5
		doins "${FILESDIR}/auroracoin-qt.protocol"
		dosym "../../kservices5/auroracoin-qt.protocol" "/usr/share/kde4/services/auroracoin-qt.protocol"
	fi
}

update_caches() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	update_caches

	elog "To have ${PN} automatically use Tor when it's running, be sure your"
	elog "'torrc' config file has 'ControlPort' and 'CookieAuthentication' setup"
	elog "correctly, and add your user to the 'tor' user group."
}

pkg_postrm() {
	update_caches
}
