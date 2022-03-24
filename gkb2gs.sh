#!/usr/bin/env bash

# Prevent tainting variables via environment
# See: https://gist.github.com/duxsco/fad211d5828e09d0391f018834f955c9
unset DST_CONFIG EBUILD KERNEL_VERSION OVERWRITE_CONFIG SRC_CONFIG SRC_FOLDER USE_LATEST_AVAILABLE_KERNEL_VERSION VERSION_GENTOO_KERNEL_BIN VERSION_GENTOO_SOURCES

function help() {
cat <<EOF
${0##*\/} saves the kernel config of sys-kernel/gentoo-kernel-bin in /etc/kernels/

You can choose a specific version, e.g.:
bash ${0##*\/} -v 5.15.29

Or, you can select the latest available version:
bash ${0##*\/} -l

To print this help:
bash ${0##*\/} -h
EOF
}

while getopts hlv: opt; do
    case $opt in
        l) USE_LATEST_AVAILABLE_KERNEL_VERSION="true";;
        v) KERNEL_VERSION="$OPTARG";;
        h) help; exit 0;;
        ?) help; exit 1;;
    esac
done

if  { [[ -z ${USE_LATEST_AVAILABLE_KERNEL_VERSION} ]] && [[ -z ${KERNEL_VERSION} ]]; } || \
    { [[ -n ${USE_LATEST_AVAILABLE_KERNEL_VERSION} ]] && [[ -n ${KERNEL_VERSION} ]]; }; then
cat <<EOF
You have to execute this script either with "-l" or "-v" flag.
For more information, execute:
bash ${0##*\/} -h
EOF
    exit 1
fi

if [[ -n ${USE_LATEST_AVAILABLE_KERNEL_VERSION} ]]; then
    VERSION_GENTOO_SOURCES="$(qatom -F "%{PV}" "$(portageq best_visible / gentoo-sources)")"
    VERSION_GENTOO_KERNEL_BIN="$(qatom -F "%{PV}" "$(portageq best_visible / gentoo-kernel-bin)")"

    if [[ "${VERSION_GENTOO_SOURCES}" == "${VERSION_GENTOO_KERNEL_BIN}" ]]; then
        KERNEL_VERSION="${VERSION_GENTOO_KERNEL_BIN}"
    else
cat <<EOF
Latest available versions of gentoo-kernel-bin and gentoo-sources differ!
Use the "-v" flag. For more information, execute:
bash ${0##*\/} -h
EOF
        exit 1
    fi
fi

# shellcheck disable=SC2001
DST_CONFIG="/etc/kernels/kernel-config-$(sed 's/\([0-9]*\.[0-9]*\.[0-9]*\)\(.*\)/\1-gentoo\2/' <<< "${KERNEL_VERSION}")-$(arch)"

if [[ -f ${DST_CONFIG} ]]; then
    read -r -p "Do you want to overwrite ${DST_CONFIG}? (y/N) " OVERWRITE_CONFIG

    if [[ ${OVERWRITE_CONFIG} =~ ^[yY]$ ]]; then
        rm "${DST_CONFIG}"
    else
        echo "Aborting..."
        exit 0
    fi
fi

EBUILD="$(portageq get_repo_path / gentoo)/sys-kernel/gentoo-kernel-bin/gentoo-kernel-bin-${KERNEL_VERSION}.ebuild"

if [ -f "${EBUILD}" ]; then
    ebuild "${EBUILD}" clean prepare
    SRC_FOLDER="$(portageq envvar PORTAGE_TMPDIR)/portage/sys-kernel/gentoo-kernel-bin-${KERNEL_VERSION}"
    SRC_CONFIG="${SRC_FOLDER}/work/usr/src/linux-${KERNEL_VERSION}-gentoo-dist/.config"

    rsync -a "${SRC_CONFIG}" "${DST_CONFIG}"

    ebuild "${EBUILD}" clean
else
    echo -e "Something went wrong! The following file doesn't exist:\n${EBUILD}"
    exit 1
fi

echo "${DST_CONFIG} created!"
