# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="System-wide Auroracoin services user"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( auroracoin )

acct-user_add_deps
