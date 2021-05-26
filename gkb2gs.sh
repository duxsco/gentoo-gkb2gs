#!/bin/bash

set -ex

VERSION="${1:-$(emerge --search "%^sys-kernel/gentoo-kernel-bin$" | grep -i "latest version available" | awk '{print $NF}')}"

if [ -z "$1" ] && [ "${VERSION}" != "$(emerge --search "%^sys-kernel/gentoo-sources$" | grep -i "latest version available" | awk '{print $NF}')" ]; then
  echo "versions differ"
  exit 1
fi

ebuild "$(portageq get_repo_path / gentoo)/sys-kernel/gentoo-kernel-bin/gentoo-kernel-bin-${VERSION}.ebuild" clean prepare
SRC_FOLDER="/var/tmp/portage/sys-kernel/gentoo-kernel-bin-${VERSION}"
SRC_CONFIG="${SRC_FOLDER}/work/usr/src/linux-${VERSION}-gentoo-dist/.config"
DST_CONFIG="/etc/kernels/kernel-config-$(sed 's/\([0-9]*\.[0-9]*\.[0-9]*\)/\1-gentoo/' <<< "${VERSION}")-x86_64"

if [ ! -f "${DST_CONFIG}" ]; then
  cp -v "${SRC_CONFIG}" "${DST_CONFIG}"
fi

cmp "${SRC_CONFIG}" "${DST_CONFIG}"
rm -rf "${SRC_FOLDER}"
if [ ! "$(ls -A /var/tmp/portage/sys-kernel)" ]; then
  rmdir /var/tmp/portage/sys-kernel
fi

echo $?
