#!/usr/bin/env bash

# Prevent tainting variables via environment
# See: https://gist.github.com/duxsco/fad211d5828e09d0391f018834f955c9
unset GENTOO_KERNEL_CONFIG GENTOO_KERNEL_EBUILD GENTOO_KERNEL_VERSION GENTOO_SOURCES_CONFIG GENTOO_SOURCES_EBUILD GENTOO_SOURCES_VERSION OVERWRITE_CONFIG

function help() {
cat <<EOF
${0##*\/} saves the kernel config of sys-kernel/gentoo-kernel in /etc/kernels/ to be used for building sys-kernel/gentoo-sources.

You can autoselect best visible versions of both packages:
bash ${0##*\/}

Or, specify certain versions with following flags:
"-k" for sys-kernel/gentoo-kernel
"-s" for sys-kernel/gentoo-sources which makes the use of "-k" mandatory

The following extracts =sys-kernel/gentoo-kernel-5.15.32 config to be used for the best visible version of sys-kernel/gentoo-sources:
bash ${0##*\/} -k 5.15.32

The following extracts =sys-kernel/gentoo-kernel-5.15.32 config to be used for =sys-kernel/gentoo-sources-5.15.32-r1:
bash ${0##*\/} -k 5.15.32 -s 5.15.32-r1

To print this help:
bash ${0##*\/} -h
EOF
}

while getopts k:hs: opt; do
    case $opt in
        k) GENTOO_KERNEL_VERSION="$OPTARG";;
        s) GENTOO_SOURCES_VERSION="$OPTARG";;
        h) help; exit 0;;
        ?) help; exit 1;;
    esac
done

########################
# save version numbers #
########################

if [[ -z ${GENTOO_SOURCES_VERSION} ]]; then
    GENTOO_SOURCES_VERSION="$(qatom -F "%{PVR}" "$(portageq best_visible / sys-kernel/gentoo-sources)")"
fi

if [[ -z ${GENTOO_KERNEL_VERSION} ]]; then
    GENTOO_KERNEL_VERSION="$(qatom -F "%{PVR}" "$(portageq best_visible / sys-kernel/gentoo-kernel)")"

    if [[ ${GENTOO_KERNEL_VERSION} != "${GENTOO_SOURCES_VERSION}" ]]; then
cat <<EOF
Versions of sys-kernel/gentoo-kernel and sys-kernel/gentoo-sources differ!
Use the "-k" flag. For more information, execute:
bash ${0##*\/} -h
EOF
        exit 1
    fi
fi

#########################
# check version numbers #
#########################

GENTOO_KERNEL_EBUILD="$(portageq get_repo_path / gentoo)/sys-kernel/gentoo-kernel/gentoo-kernel-${GENTOO_KERNEL_VERSION}.ebuild"
GENTOO_SOURCES_EBUILD="$(portageq get_repo_path / gentoo)/sys-kernel/gentoo-sources/gentoo-sources-${GENTOO_SOURCES_VERSION}.ebuild"

if [[ ! -f ${GENTOO_KERNEL_EBUILD} ]]; then
    echo "=sys-kernel/gentoo-kernel-${GENTOO_KERNEL_VERSION} doesn't exist! Aborting..."
    exit 1
fi

if [[ ! -f ${GENTOO_SOURCES_EBUILD} ]]; then
    echo "=sys-kernel/gentoo-sources-${GENTOO_SOURCES_VERSION} doesn't exist! Aborting..."
    exit 1
fi

#########################
# save paths to configs #
#########################

GENTOO_KERNEL_CONFIG="$(portageq envvar PORTAGE_TMPDIR)/portage/sys-kernel/gentoo-kernel-${GENTOO_KERNEL_VERSION}/work/modprep/.config"

# shellcheck disable=SC2001
GENTOO_SOURCES_CONFIG="/etc/kernels/kernel-config-$(sed 's/\([0-9]*\.[0-9]*\.[0-9]*\)\(.*\)/\1-gentoo\2/' <<< "${GENTOO_SOURCES_VERSION}")-$(arch)"

if [[ -f ${GENTOO_SOURCES_CONFIG} ]]; then
    read -r -p "Do you want to overwrite \"${GENTOO_SOURCES_CONFIG}\"? (y/N) " OVERWRITE_CONFIG

    if [[ ${OVERWRITE_CONFIG} =~ ^[yY]$ ]]; then
        rm "${GENTOO_SOURCES_CONFIG}"
    else
        echo "Aborting..."
        exit 0
    fi
fi

###########################
# extract and save config #
###########################

ebuild "${GENTOO_KERNEL_EBUILD}" clean prepare configure
rsync -a "${GENTOO_KERNEL_CONFIG}" "${GENTOO_SOURCES_CONFIG}"
ebuild "${GENTOO_KERNEL_EBUILD}" clean

echo "${GENTOO_SOURCES_CONFIG} created!"
