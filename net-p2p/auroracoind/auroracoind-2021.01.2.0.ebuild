# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DB_VER="5.3"
inherit autotools bash-completion-r1 db-use systemd

MyPN="Auroracoin"
MyP="${MyPN}-${PV}"

DESCRIPTION="Original Auroracoin crypto-currency wallet for automated services"
HOMEPAGE="https://auroracoin.is/"
SRC_URI="https://github.com/aurarad/${MyPN}/archive/${PV}.tar.gz -> ${MyP}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+asm examples +system-leveldb test upnp +wallet zeromq"
RESTRICT="!test? ( test )"

DEPEND="
	acct-group/auroracoin
	acct-user/auroracoin
	>=dev-libs/boost-1.52.0:=[threads(+)]
	dev-libs/libevent:=
	>dev-libs/libsecp256k1-0.1_pre20170321:=[recovery]
	>=dev-libs/univalue-1.0.4:=
	system-leveldb? ( virtual/bitcoin-leveldb )
	upnp? ( >=net-libs/miniupnpc-1.9.20150916:= )
	wallet? ( sys-libs/db:$(db_ver_to_slot "${DB_VER}")=[cxx] )
	zeromq? ( net-libs/zeromq:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=sys-devel/autoconf-2.69
	>=sys-devel/automake-1.13
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
	#sed -i 's/^\(complete -F _bitcoind bitcoind\) bitcoin-qt$/\1/' contrib/${PN}.bash-completion || die

	eapply "${FILESDIR}/2021.01.2.0_system_leveldb.patch"

	default

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
		--without-qtdbus
		--without-qrencode
		$(use_with upnp miniupnpc)
		$(use_enable upnp upnp-default)
		$(use_enable test tests)
		$(use_enable wallet)
		$(use_enable zeromq zmq)
		--with-daemon
		--disable-util-cli
		--disable-util-tx
		--disable-util-wallet
		--disable-bench
		--without-libs
		--without-gui
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

	insinto /etc/auroracoin
	newins share/examples/auroracoin.conf auroracoin.conf
	fowners auroracoin:auroracoin /etc/auroracoin/auroracoin.conf
	fperms 600 /etc/auroracoin/auroracoin.conf

	#newconfd "contrib/init/auroracoind.openrcconf" ${PN}
	#newinitd "contrib/init/auroracoind.openrc" ${PN}
	#systemd_newunit "contrib/init/auroracoind.service" "auroracoind.service"

	keepdir /var/lib/auroracoin/.auroracoin
	fperms 700 /var/lib/auroracoin
	fowners auroracoin:auroracoin /var/lib/auroracoin/
	fowners auroracoin:auroracoin /var/lib/auroracoin/.auroracoin
	dosym ../../../../etc/auroracoin/auroracoin.conf /var/lib/auroracoin/.bitcoin/auroracoin.conf

	#doman "${FILESDIR}/auroracoin.conf.5"

	use zeromq && dodoc doc/zmq.md

	#newbashcomp contrib/${PN}.bash-completion ${PN}

	if use examples; then
		docinto examples
		dodoc -r contrib/{linearize,qos}
		use zeromq && dodoc -r contrib/zmq
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}/auroracoind.logrotate-r1" auroracoind
}

pkg_postinst() {
	elog "To have ${PN} automatically use Tor when it's running, be sure your"
	elog "'torrc' config file has 'ControlPort' and 'CookieAuthentication' setup"
	elog "correctly, and:"
	elog "- Using an init script: add the 'auroracoin' user to the 'tor' user group."
	elog "- Running auroracoind directly: add that user to the 'tor' user group."
}
