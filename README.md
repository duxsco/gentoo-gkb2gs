# gkb2gs - gentoo-kernel-bin config to gentoo-sources

The script `gkb2gs.sh` extracts the kernel config from `sys-kernel/gentoo-kernel-bin` and saves that into `/etc/kernels/`.

```bash
$ bash gkb2gs.sh -h
gkb2gs.sh saves the kernel config of sys-kernel/gentoo-kernel-bin in /etc/kernels/

You can choose a specific version, e.g.:
bash gkb2gs.sh -v 5.15.29

Or, you can select the latest available version:
bash gkb2gs.sh -l

To print this help:
bash gkb2gs.sh -h
```

To use the current LTS Linux kernel (as of March 22th 2022) do the following:

1. Create the directory `/etc/kernels`
2. Add `sys-kernel/gentoo-kernel-bin -initramfs` to `package.use`. We just extract the config and don't need the initramfs.
3. Add the following to `package.accept_keywords`:

```
sys-kernel/gentoo-kernel-bin ~amd64
sys-kernel/gentoo-sources ~amd64
```

4. Add the following to `package.mask`:

```
>=sys-kernel/gentoo-kernel-bin-5.16
>=sys-kernel/gentoo-sources-5.16
```

5. Execute the script as root, e.g.:

```bash
# bash gkb2gs.sh -l
 * linux-5.15.tar.xz BLAKE2B SHA512 size ;-) ...                                                                [ ok ]
 * genpatches-5.15-32.base.tar.xz BLAKE2B SHA512 size ;-) ...                                                   [ ok ]
 * genpatches-5.15-32.extras.tar.xz BLAKE2B SHA512 size ;-) ...                                                 [ ok ]
 * gentoo-kernel-5.15.30-1.amd64.xpak BLAKE2B SHA512 size ;-) ...                                               [ ok ]
 * checking ebuild checksums ;-) ...                                                                            [ ok ]
 * checking miscfile checksums ;-) ...                                                                          [ ok ]
>>> Unpacking source...
>>> Unpacking linux-5.15.tar.xz to /var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.15.30/work
>>> Unpacking genpatches-5.15-32.base.tar.xz to /var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.15.30/work
>>> Unpacking genpatches-5.15-32.extras.tar.xz to /var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.15.30/work
>>> Unpacking gentoo-kernel-5.15.30-1.amd64.xpak to /var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.15.30/work
unpack gentoo-kernel-5.15.30-1.amd64.xpak: file format not recognized. Ignoring.
 * Unpacking gentoo-kernel-5.15.30-1.amd64.xpak ...                                                             [ ok ]
>>> Source unpacked in /var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.15.30/work
>>> Preparing source in /var/tmp/portage/sys-kernel/gentoo-kernel-bin-5.15.30/work ...
 * Applying 1000_linux-5.15.1.patch ...                                                                         [ ok ]
 * Applying 1001_linux-5.15.2.patch ...                                                                         [ ok ]
 * Applying 1002_linux-5.15.3.patch ...                                                                         [ ok ]
 * Applying 1003_linux-5.15.4.patch ...                                                                         [ ok ]
 * Applying 1004_linux-5.15.5.patch ...                                                                         [ ok ]
 * Applying 1005_linux-5.15.6.patch ...                                                                         [ ok ]
 * Applying 1006_linux-5.15.7.patch ...                                                                         [ ok ]
 * Applying 1007_linux-5.15.8.patch ...                                                                         [ ok ]
 * Applying 1008_linux-5.15.9.patch ...                                                                         [ ok ]
 * Applying 1009_linux-5.15.10.patch ...                                                                        [ ok ]
 * Applying 1010_linux-5.15.11.patch ...                                                                        [ ok ]
 * Applying 1011_linux-5.15.12.patch ...                                                                        [ ok ]
 * Applying 1012_linux-5.15.13.patch ...                                                                        [ ok ]
 * Applying 1013_linux-5.15.14.patch ...                                                                        [ ok ]
 * Applying 1014_linux-5.15.15.patch ...                                                                        [ ok ]
 * Applying 1015_linux-5.15.16.patch ...                                                                        [ ok ]
 * Applying 1016_linux-5.15.17.patch ...                                                                        [ ok ]
 * Applying 1017_linux-5.15.18.patch ...                                                                        [ ok ]
 * Applying 1018_linux-5.15.19.patch ...                                                                        [ ok ]
 * Applying 1019_linux-5.15.20.patch ...                                                                        [ ok ]
 * Applying 1020_linux-5.15.21.patch ...                                                                        [ ok ]
 * Applying 1021_linux-5.15.22.patch ...                                                                        [ ok ]
 * Applying 1022_linux-5.15.23.patch ...                                                                        [ ok ]
 * Applying 1023_linux-5.15.24.patch ...                                                                        [ ok ]
 * Applying 1024_linux-5.15.25.patch ...                                                                        [ ok ]
 * Applying 1025_linux-5.15.26.patch ...                                                                        [ ok ]
 * Applying 1026_linux-5.15.27.patch ...                                                                        [ ok ]
 * Applying 1027_linux-5.15.28.patch ...                                                                        [ ok ]
 * Applying 1028_linux-5.15.29.patch ...                                                                        [ ok ]
 * Applying 1029_linux-5.15.30.patch ...                                                                        [ ok ]
 * Applying 1500_XATTR_USER_PREFIX.patch ...                                                                    [ ok ]
 * Applying 1510_fs-enable-link-security-restrictions-by-default.patch ...                                      [ ok ]
 * Applying 2000_BT-Check-key-sizes-only-if-Secure-Simple-Pairing-enabled.patch ...
patching file net/bluetooth/hci_conn.c
Hunk #1 succeeded at 1395 with fuzz 1 (offset 123 lines).                                                       [ ok ]
 * Applying 2900_tmp513-Fix-build-issue-by-selecting-CONFIG_REG.patch ...                                       [ ok ]
 * Applying 2920_sign-file-patch-for-libressl.patch ...                                                         [ ok ]
 * Applying 3000_Support-printing-firmware-info.patch ...                                                       [ ok ]
 * Applying 4567_distro-Gentoo-Kconfig.patch ...                                                                [ ok ]
>>> Source prepared.
/etc/kernels/kernel-config-5.15.30-gentoo-x86_64 created!
```

## Other Gentoo Linux repos

https://github.com/duxsco?tab=repositories&q=gentoo-
