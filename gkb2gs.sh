#!/usr/bin/env bash

set -x
set -euo pipefail

VERSION="${1:-$(emerge --search "%^sys-kernel/gentoo-kernel-bin$" | grep -Po "Latest version available:[[:space:]]*\K.*")}"

if [[ $# -eq 0 ]] && [[ ${VERSION} != $(emerge --search "%^sys-kernel/gentoo-sources$" | grep -Po "Latest version available:[[:space:]]*\K.*") ]]; then
  echo "versions differ"
  exit 1
fi

ebuild "$(portageq get_repo_path / gentoo)/sys-kernel/gentoo-kernel-bin/gentoo-kernel-bin-${VERSION}.ebuild" clean prepare
SRC_FOLDER="$(portageq envvar PORTAGE_TMPDIR)/portage/sys-kernel/gentoo-kernel-bin-${VERSION}"
SRC_CONFIG="${SRC_FOLDER}/work/usr/src/linux-${VERSION}-gentoo-dist/.config"
# shellcheck disable=SC2001
DST_CONFIG="/etc/kernels/kernel-config-$(sed 's/\([0-9]*\.[0-9]*\.[0-9]*\)\(.*\)/\1-gentoo\2/' <<< "${VERSION}")-$(arch)"

if [[ ! -f ${DST_CONFIG} ]]; then
  cp -v "${SRC_CONFIG}" "${DST_CONFIG}"
fi

cmp "${SRC_CONFIG}" "${DST_CONFIG}"
rm -rf "${SRC_FOLDER}"
if [[ ! $(ls -A "$(portageq envvar PORTAGE_TMPDIR)/portage/sys-kernel") ]]; then
  rmdir "$(portageq envvar PORTAGE_TMPDIR)/portage/sys-kernel"
fi

echo $?
