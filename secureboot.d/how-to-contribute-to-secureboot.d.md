# Glossary
- Vendor is the distribution name or company that signs the EFI files against Microsoft CA.
 - Vendor examples:
    - debian
    - ubuntu
    - fedora.

The vendor example should match the EFI directory where it saves their files.
If Fedora saves their files in /boot/efi/fedora/grub.cfg do not create 'Fedora' instead.

- EFI Platforms
 - The EFI Platforms depend on the CPU architecture.
 - EFI platforms examples:
    - x64
    - ia32
 - You probably have just support for x64.

# Where to save your files in Super Grub2 Disk source code (Generic)
```
secureboot.d/efiplatform/vendor/download-efiplatform-vendor
```
# Where to save your files in Super Grub2 Disk source code (Debian)
```
secureboot.d/x64/debian/download-x64-debian
```

# Where to save your description (Generic)
```
secureboot.d/efiplatform/vendor/description
```
# Where to save your files in Super Grub2 Disk source code (Fedora)
```
secureboot.d/x64/fedora/description
```

# What it's inside description
It should have a **single line** which should describe all of the systems that the shim can boot to:
```
RedHat/Fedora
```

# What about download-efiplatform-vendor script?

In our debian example we would create:

`secureboot.d/x64/debian/download-x64-debian`

script.

We would add the execution bit to it.

`chmod +x secureboot.d/x64/debian/download-x64-debian`

- The script needs to create a temporary directory in the directory where it's run.
- This temporary directory needs to be removed once the script finishes.
- Script can read two environment variables
    - SHIM_FULLPATH_BINARY
    - GRUB_FULLPATH_BINARY
- Binary files need to copied there
- Script can read two environment variables
    - SHIM_FULLPATH_SOURCE_CODE_TAR_GZ
    - GRUB_FULLPATH_SOURCE_CODE_TAR_GZ
- Source code (As a tar.gz) needs to be copied there
- Also it's advised that the script return code is 0 if everything is ok, non 0 if there was a problem (like wget not being able to download binaries).

E.g. SHIM_FULLPATH_BINARY is set to `/tmp/build_sgd/secureboot-binaries/vendors/debian/shimx64.efi` and your downloaded file is: `mytmpdir/shimx64.efi.signed`.
So it's just about doing something similar to:

`cp mytmpdir/shimx64.efi.signed /tmp/build_sgd/secureboot-binaries/vendors/debian/shimx64.efi`.

Supported programming languages for these scripts are python and bash. Feel free to ask support for more of them if you actually need them.

Also check other vendors examples on the supergrub git repo [https://github.com/supergrub/supergrub/secureboot.d/x64/debian/](https://github.com/supergrub/supergrub/secureboot.d/x64/debian/) so that you can use them as templates.
