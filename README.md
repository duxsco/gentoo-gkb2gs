# gkb2gs - gentoo-kernel config to gentoo-sources

⚠️ `app-portage/portage-utils` is required for the `gkb2gs.sh` to function! ⚠️

The script `gkb2gs.sh` extracts the kernel config from `sys-kernel/gentoo-kernel` and saves that into `/etc/kernels/`.

```bash
$ bash gkb2gs.sh -h
gkb2gs.sh saves the kernel config of sys-kernel/gentoo-kernel in /etc/kernels/ to be used for building sys-kernel/gentoo-sources.

You can autoselect best visible versions of both packages:
bash gkb2gs.sh

Or, specify certain versions with following flags:
"-k" for sys-kernel/gentoo-kernel
"-s" for sys-kernel/gentoo-sources which makes the use of "-k" mandatory

The following extracts =sys-kernel/gentoo-kernel-5.15.32 config to be used for the best visible version of sys-kernel/gentoo-sources:
bash gkb2gs.sh -k 5.15.32

The following extracts =sys-kernel/gentoo-kernel-5.15.32 config to be used for =sys-kernel/gentoo-sources-5.15.32-r1:
bash gkb2gs.sh -k 5.15.32 -s 5.15.32-r1

To print this help:
bash gkb2gs.sh -h
```

To use the current LTS Linux kernel (as of March 22th 2022) do the following:

1. Create the directory `/etc/kernels`
2. Add `sys-kernel/gentoo-kernel -initramfs` to `package.use`. We just extract the config and don't need the initramfs.
3. Add the following to `package.accept_keywords`:

```
sys-kernel/gentoo-kernel ~amd64
sys-kernel/gentoo-sources ~amd64
```

4. Add the following to `package.mask`:

```
>=sys-kernel/gentoo-kernel-5.16
>=sys-kernel/gentoo-sources-5.16
```

5. Execute the script as root, e.g.:

```bash
➤ bash gkb2gs.sh
Do you want to overwrite "/etc/kernels/kernel-config-5.15.33-gentoo-x86_64"? (y/N) y
 * linux-5.15.tar.xz BLAKE2B SHA512 size ;-) ...                                                                [ ok ]
 * genpatches-5.15-36.base.tar.xz BLAKE2B SHA512 size ;-) ...                                                   [ ok ]
 * genpatches-5.15-36.extras.tar.xz BLAKE2B SHA512 size ;-) ...                                                 [ ok ]
 * gentoo-kernel-config-g1.tar.gz BLAKE2B SHA512 size ;-) ...                                                   [ ok ]
 * kernel-x86_64-fedora.config.5.15.14 BLAKE2B SHA512 size ;-) ...                                              [ ok ]
 * Checking whether python3_10 is suitable ...
 *   >=dev-lang/python-3.10.0_p1-r1:3.10 ...                                                                    [ ok ]
 * Using python3.10 to build (via PYTHON_COMPAT iteration)
>>> Unpacking source...
>>> Unpacking linux-5.15.tar.xz to /var/tmp/portage/sys-kernel/gentoo-kernel-5.15.33/work
>>> Unpacking genpatches-5.15-36.base.tar.xz to /var/tmp/portage/sys-kernel/gentoo-kernel-5.15.33/work
>>> Unpacking genpatches-5.15-36.extras.tar.xz to /var/tmp/portage/sys-kernel/gentoo-kernel-5.15.33/work
>>> Unpacking gentoo-kernel-config-g1.tar.gz to /var/tmp/portage/sys-kernel/gentoo-kernel-5.15.33/work
>>> Unpacking kernel-x86_64-fedora.config.5.15.14 to /var/tmp/portage/sys-kernel/gentoo-kernel-5.15.33/work
unpack kernel-x86_64-fedora.config.5.15.14: file format not recognized. Ignoring.
>>> Source unpacked in /var/tmp/portage/sys-kernel/gentoo-kernel-5.15.33/work
>>> Preparing source in /var/tmp/portage/sys-kernel/gentoo-kernel-5.15.33/work/linux-5.15 ...
...
make[1]: Leaving directory '/var/tmp/portage/sys-kernel/gentoo-kernel-5.15.33/work/modprep'
>>> Source configured.
/etc/kernels/kernel-config-5.15.33-gentoo-x86_64 created!
```

## Other Gentoo Linux repos

https://github.com/duxsco?tab=repositories&q=gentoo-
