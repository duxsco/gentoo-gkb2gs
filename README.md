# gkb2gs - gentoo-kernel-bin config to gentoo-sources

The script `gkb2gs.sh` extracts the kernel config from `sys-kernel/gentoo-kernel-bin` and saves that into `/etc/kernels/`.

To use the current LTS Linux kernel (as of August 7th 2021) do the following:

1. Create the directory `/etc/kernels`
2. Add `sys-kernel/gentoo-kernel-bin -initramfs` to `package.use`. We just extract the config and don't need the initramfs.
3. Add the following to `package.accept_keywords`:

```
sys-kernel/gentoo-kernel-bin ~amd64
sys-kernel/gentoo-sources ~amd64
```

4. Add the following to `package.mask`:

```
>=sys-kernel/gentoo-kernel-bin-5.11
>=sys-kernel/gentoo-sources-5.11
```

5. Execute the script as root, e.g.:

```bash
# gkb2gs.sh
++ emerge --search '%^sys-kernel/gentoo-kernel-bin$'
++ grep -i 'latest version available'
++ awk '{print $NF}'
+ VERSION=5.10.14
+ '[' -z '' ']'
++ emerge --search '%^sys-kernel/gentoo-sources$'
++ grep -i 'latest version available'
++ awk '{print $NF}'
+ '[' 5.10.14 '!=' 5.10.14 ']'
++ portageq get_repo_path / gentoo
+ ebuild /var/db/repos/gentoo/sys-kernel/gentoo-kernel-bin/gentoo-kernel-bin-5.10.14.ebuild clean prepare
 * gentoo-kernel-5.10.14-1.amd64.xpak BLAKE2B SHA512 size ;-) ...                                  [ ok ]
 * checking ebuild checksums ;-) ...                                                               [ ok ]
 * checking miscfile checksums ;-) ...                                                             [ ok ]
>>> Unpacking source...
 * Unpacking gentoo-kernel-5.10.14-1.amd64.xpak ...                                                [ ok ]
>>> Source unpacked in /var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.10.14/work
>>> Preparing source in /var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.10.14/work ...
>>> Source prepared.
+ SRC_FOLDER=/var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.10.14
+ SRC_CONFIG=/var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.10.14/work/usr/src/linux-5.10.14/.config
++ sed 's/\([0-9]*\.[0-9]*\.[0-9]*\)/\1-gentoo/'
+ DST_CONFIG=/etc/kernels/kernel-config-5.10.14-gentoo-x86_64
+ '[' '!' -f /etc/kernels/kernel-config-5.10.14-gentoo-x86_64 ']'
+ cp -v /var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.10.14/work/usr/src/linux-5.10.14/.config /etc/kernels/kernel-config-5.10.14-gentoo-x86_64
'/var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.10.14/work/usr/src/linux-5.10.14/.config' -> '/etc/kernels/kernel-config-5.10.14-gentoo-x86_64'
+ cmp /var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.10.14/work/usr/src/linux-5.10.14/.config /etc/kernels/kernel-config-5.10.14-gentoo-x86_64
+ rm -rf /var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.10.14
++ ls -A /var/tmp/portage/sys-kernel
+ '[' '!' '' ']'
+ rmdir /var/tmp/portage/sys-kernel
+ echo 0
0
```

You can also specify a version with `gkb2gs.sh 5.10.13`.

## Other Gentoo Linux repos

https://github.com/duxsco?tab=repositories&q=gentoo-
