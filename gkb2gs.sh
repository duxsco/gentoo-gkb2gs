#!/usr/bin/env bash

# Prevent tainting variables via environment
# See: https://gist.github.com/duxsco/fad211d5828e09d0391f018834f955c9
unset gentoo_kernel_bin_config gentoo_kernel_bin_ebuild gentoo_kernel_bin_version gentoo_sources_config gentoo_sources_ebuild gentoo_sources_version overwrite_config selinux_enforcing

function help() {
cat <<EOF
${0##*\/} saves the kernel config of sys-kernel/gentoo-kernel-bin in /etc/kernels/ to be used for building sys-kernel/gentoo-sources.

You can autoselect best visible versions of both packages:
bash ${0##*\/}

Or, specify certain versions with following flags:
"-b" for sys-kernel/gentoo-kernel-bin
"-s" for sys-kernel/gentoo-sources which makes the use of "-b" mandatory

The following extracts =sys-kernel/gentoo-kernel-bin-5.15.32 config to be used for the best visible version of sys-kernel/gentoo-sources:
bash ${0##*\/} -b 5.15.32

The following extracts =sys-kernel/gentoo-kernel-bin-5.15.32 config to be used for =sys-kernel/gentoo-sources-5.15.32-r1:
bash ${0##*\/} -b 5.15.32 -s 5.15.32-r1

To print this help:
bash ${0##*\/} -h
EOF
}

while getopts b:hs: opt; do
    case $opt in
        b) gentoo_kernel_bin_version="$OPTARG";;
        s) gentoo_sources_version="$OPTARG";;
        h) help; exit 0;;
        ?) help; exit 1;;
    esac
done

###########
# selinux #
###########

if [[ -f /sys/fs/selinux/enforce ]] && [[ $(</sys/fs/selinux/enforce) -eq 1 ]]; then
    selinux_enforcing="true"
else
    selinux_enforcing="false"
fi

########################
# save version numbers #
########################

if [[ -z ${gentoo_sources_version} ]]; then
    gentoo_sources_version="$(qatom -F "%{PVR}" "$(portageq best_visible / sys-kernel/gentoo-sources)")"
fi

if [[ -z ${gentoo_kernel_bin_version} ]]; then
    gentoo_kernel_bin_version="$(qatom -F "%{PVR}" "$(portageq best_visible / sys-kernel/gentoo-kernel-bin)")"

    if [[ ${gentoo_kernel_bin_version} != "${gentoo_sources_version}" ]]; then
cat <<EOF
Versions of sys-kernel/gentoo-kernel-bin and sys-kernel/gentoo-sources differ!
Use the "-b" flag. For more information, execute:
bash ${0##*\/} -h
EOF
        exit 1
    fi
fi

#########################
# check version numbers #
#########################

gentoo_kernel_bin_ebuild="$(portageq get_repo_path / gentoo)/sys-kernel/gentoo-kernel-bin/gentoo-kernel-bin-${gentoo_kernel_bin_version}.ebuild"
gentoo_sources_ebuild="$(portageq get_repo_path / gentoo)/sys-kernel/gentoo-sources/gentoo-sources-${gentoo_sources_version}.ebuild"

if [[ ! -f ${gentoo_kernel_bin_ebuild} ]]; then
    echo "=sys-kernel/gentoo-kernel-bin-${gentoo_kernel_bin_version} doesn't exist! Aborting..."
    exit 1
fi

if [[ ! -f ${gentoo_sources_ebuild} ]]; then
    echo "=sys-kernel/gentoo-sources-${gentoo_sources_version} doesn't exist! Aborting..."
    exit 1
fi

#########################
# save paths to configs #
#########################

gentoo_kernel_bin_config="$(portageq envvar PORTAGE_TMPDIR)/portage/sys-kernel/gentoo-kernel-bin-${gentoo_kernel_bin_version}/work/modprep/.config"

# shellcheck disable=SC2001
gentoo_sources_config="/etc/kernels/kernel-config-$(sed 's/\([0-9]*\.[0-9]*\.[0-9]*\)\(.*\)/\1-gentoo\2/' <<< "${gentoo_sources_version}")-$(arch)"

if [[ -f ${gentoo_sources_config} ]]; then
    read -r -p "Do you want to overwrite \"${gentoo_sources_config}\"? (y/N) " overwrite_config

    if [[ ${overwrite_config} =~ ^[yY]$ ]]; then
        rm "${gentoo_sources_config}"
    else
        echo "Aborting..."
        exit 0
    fi
fi

###########################
# extract and save config #
###########################

if [[ ${selinux_enforcing} == true ]]; then
    runcon -t portage_t -- ebuild "${gentoo_kernel_bin_ebuild}" clean prepare configure
    rsync -a "${gentoo_kernel_bin_config}" "${gentoo_sources_config}"
    runcon -t portage_t -- ebuild "${gentoo_kernel_bin_ebuild}" clean
else
    ebuild "${gentoo_kernel_bin_ebuild}" clean prepare configure
    rsync -a "${gentoo_kernel_bin_config}" "${gentoo_sources_config}"
    ebuild "${gentoo_kernel_bin_ebuild}" clean
fi

echo "${gentoo_sources_config} created!"
