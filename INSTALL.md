This file contains instructions for building Super Grub2 Disk.

For more advanced instructions you can check: [DEVELOPMENT.md](DEVELOPMENT.md) file.

# Requirements

Super Grub2 Disk tends to depend heavily on the latest features of GRUB2, so using it with older versions of GRUB2 is very likely to fail. Currently Super Grub2 Disk requires GRUB 2.02 (as opposed to GRUB 1.99, which is GRUB2, but is not GRUB 2.0). Newer versions of GRUB2 than 2.02 will probably work with this version of Super Grub2 Disk's scripts, but I can't make any guarantees about the future.

Also needed:

- GNU xorriso (it's a dependency of the grub-mkrescue utility which is part of GRUB2).
- Unifont (which is also already a soft dependency of GRUB2).
- mtools (Till it's fixed in Debian. Check Debian bug number: 774910 ).

In practice in 2022 you can get all of these requirements met in Debian Bullseye you need to run:

```
apt-get update
apt-get install sudo \
                xorriso \
                git \
                gettext \
                unifont \
                mtools \
                zip \
                rsync \
                udev \
                python3 \
                wget \
                zstd

update-alternatives --install /usr/bin/python python /usr/bin/python3 10
apt-get -y build-dep grub2
```

The suggested build method is based on Docker so you do not need to install any of these requirements into your own system.
You would only need to install those requirements if you use an alternative build method.

Also make sure to run the suggested commands inside a bash shell.

# Docker - Automatic build

## Docker - Requirements
You need to have docker installed and your user needs to be able to create docker instances.
These instructions are for Ubuntu 22.04 but they should work similar in other GNU/Linux distributions.

[https://linuxconfig.org/how-to-install-docker-on-ubuntu-22-04](https://linuxconfig.org/how-to-install-docker-on-ubuntu-22-04)

```
sudo apt update
sudo apt install docker.io
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo docker version
sudo docker info
sudo usermod -aG docker yourlinuxusername
```

Reboot so that changes are taken into account.

## How to build thanks to Docker

Just use the automatic builder and update `PREVIOUS_VERSION=2.04s1` if needed.

```
docker build \
  --build-arg SGD_BUILDER_UID=$(id -u) \
  --build-arg SGD_BUILDER_GID=$(id -g) \
  --tag supergrub-automatic-builder . \
  -f automatic-builder.Dockerfile
```

```
docker run \
  -it \
  --privileged \
  --env PREVIOUS_VERSION=2.04s1 \
  --env SGD_BUILDER_UID=$(id -u) \
  --env SGD_BUILDER_GID=$(id -g) \
  -v /dev:/dev \
  -v $(pwd):/supergrub2-repo:ro \
  -v $(pwd)/releases:/supergrub2-build/releases:rw \
  -v $(pwd)/news-releases:/supergrub2-build/news-releases:rw \
  -v $(pwd)/secureboot-binaries:/supergrub2-build/secureboot-binaries:rw \
  -v $(pwd)/secureboot.d/sha256sums:/supergrub2-build/secureboot.d/sha256sums:rw \
  supergrub-automatic-builder:latest
```

## Docker - Release build

When a 'Bump version commit' has been done we can:

```
git tag -a newversion -m "newversion"
```

E.g.
```
git tag -a 2.06s2-beta1 -m "2.06s2-beta1"
```


Then we just use the automatic builder where we have to update `PREVIOUS_VERSION=2.06s1-beta2` to previous Super Grub2 Disk release tag.

```
docker build \
  --build-arg SGD_BUILDER_UID=$(id -u) \
  --build-arg SGD_BUILDER_GID=$(id -g) \
  --tag supergrub-release-builder . \
  -f automatic-builder.Dockerfile
```

```
docker run \
  -it \
  --privileged \
  --env PREVIOUS_VERSION=2.06s1-beta2 \
  --env SGD_BUILDER_UID=$(id -u) \
  --env SGD_BUILDER_GID=$(id -g) \
  -v /dev:/dev \
  -v $(pwd):/supergrub2-repo:ro \
  -v $(pwd)/releases:/supergrub2-build/releases:rw \
  -v $(pwd)/news-releases:/supergrub2-build/news-releases:rw \
  -v $(pwd)/secureboot-binaries:/supergrub2-build/secureboot-binaries:rw \
  -v $(pwd)/secureboot.d/sha256sums:/supergrub2-build/secureboot.d/sha256sums:rw \
  supergrub-release-builder:latest
```

## Docker - Release files

What release files to expect once you have had a succesful build:
```
releases/2.06s2-beta1/SHA1SUMS
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1.zip.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1.zip
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1.zip.sha1
releases/2.06s2-beta1/SHA256SUMS
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1.zip.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-x86_64_efi-STANDALONE.EFI.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-i386_efi-STANDALONE.EFI.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-x86_64_efi-STANDALONE.EFI
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-i386_pc-CD.iso
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-multiarch-CD.iso
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-2.06s2-beta1-multiarch-USB.img.zip.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-x86_64_efi-CD.iso
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-i386_efi-STANDALONE.EFI
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-multiarch-CD.iso.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-i386_pc-CD.iso.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-i386_efi-CD.iso.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-i386_efi-STANDALONE.EFI.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-multiarch-CD.iso.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-x86_64_efi-STANDALONE.EFI.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-2.06s2-beta1-multiarch-USB.img.zip.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-2.06s2-beta1-multiarch-USB.img.zip
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-x86_64_efi-CD.iso.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-multiarch-CD.iso.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/grubx64-ubuntu-sourcecode.tar.gz
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/grubx64-ubuntu-sourcecode.tar.gz.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/super_grub2_disk_2.06s2-beta1_source_code.tar.gz
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/shimia32-debian-sourcecode.tar.gz.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/super_grub2_disk_2.06s2-beta1_source_code.tar.gz.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/grubia32-debian-sourcecode.tar.gz.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/shimia32-debian-sourcecode.tar.gz.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/grubx64-debian-sourcecode.tar.gz
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/shimx64-ubuntu-sourcecode.tar.gz.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/grubx64-debian-sourcecode.tar.gz.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/shimx64-ubuntu-sourcecode.tar.gz.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/grubia32-debian-sourcecode.tar.gz
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/grubx64-ubuntu-sourcecode.tar.gz.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/grubia32-debian-sourcecode.tar.gz.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/shimx64-debian-sourcecode.tar.gz
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/grubx64-debian-sourcecode.tar.gz.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/shimx64-debian-sourcecode.tar.gz.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/shimx64-ubuntu-sourcecode.tar.gz
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/shimia32-debian-sourcecode.tar.gz
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/grubia32-debian-sourcecode.tar.gz.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/shimx64-debian-sourcecode.tar.gz.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/super_grub2_disk_2.06s2-beta1_source_code.tar.gz.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/grubx64-debian-sourcecode.tar.gz.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/shimia32-debian-sourcecode.tar.gz.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/shimx64-debian-sourcecode.tar.gz.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/grubx64-ubuntu-sourcecode.tar.gz.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/shimx64-ubuntu-sourcecode.tar.gz.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/source_code/super_grub2_disk_2.06s2-beta1_source_code.tar.gz.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-x86_64_efi-CD.iso.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-i386_efi-STANDALONE.EFI.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-i386_pc-CD.iso.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-i386_efi-CD.iso.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-2.06s2-beta1-multiarch-USB.img.zip.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-multiarch-USB.img.zip.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-i386_pc-CD.iso.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-x86_64_efi-STANDALONE.EFI.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-multiarch-USB.img.zip
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-i386_efi-CD.iso.md5
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-multiarch-USB.img.zip.sha256
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-multiarch-USB.img.zip.sha1
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-i386_efi-CD.iso
releases/2.06s2-beta1/super_grub2_disk_2.06s2-beta1/supergrub2-classic-2.06s2-beta1-x86_64_efi-CD.iso.md5
releases/2.06s2-beta1/MD5SUMS
news-releases/downloads.2.06s2-beta1.html
news-releases/changes.2.06s2-beta1.html

```


# Chroot Build Method

This was the old way of building Super Grub2 Disk without messing with your regular GNU/Linux distro.
These instructions are kept here as an historical documentation or for those that do not want to use Docker.
Be warned that you might need to update them to reflect whatever it's done inside of Docker, e.g. using a more recent Debian release.

You were encouraged to use a chroot for both Grub2 and Super Grub2 Disk build. We will use a Debian Buster chroot.

Please check: Super Grub2 Disk Buster Chroot in order to learn how to setup your Super Grub2 Disk Buster chroot.

## Super Grub2 Disk Buster Chroot Setup (Optional)

### Introduction

First of all you need to know that this is simply a Debian Buster Chroot. It's a amd64 chroot.

The base OS that we are using is another Debian Buster. If you are not using a Debian based OS like Ubuntu you might need to use cdebootstrap instead of debootstrap.

Chroot in this example is going to be installed in: `/mnt/ssd/sgd_chroot_buster_amd64` .

Please adapt to your needs.
### First setup

So we cd to the parent directory of the directoy where our chroot will be created. And we invoke debootstrap

```
cd /mnt/ssd/
mkdir sgd_chroot_buster_amd64
debootstrap --arch amd64 buster sgd_chroot_buster_amd64 http://http.debian.net/debian/
```

Then we need to prepare our fstab to take care of mounting some auxiliar folders for the chroot so that it works ok. You can opt to mount them manually if you are not fancing of fstab doing it automatically. Please type all the command as root user

```
cat << EOF | sudo tee -a /etc/fstab
/proc   /mnt/ssd/sgd_chroot_buster_amd64/proc none bind,private 0 0
/dev    /mnt/ssd/sgd_chroot_buster_amd64/dev none bind,private 0 0
/sys    /mnt/ssd/sgd_chroot_buster_amd64/sys none bind,private 0 0
/dev/pts        /mnt/ssd/sgd_chroot_buster_amd64/dev/pts none bind,private 0 0
/dev/shm /mnt/ssd/sgd_chroot_buster_amd64/dev/shm none bind,private 0 0
EOF
```

I personally also add the home directory because I found it easier to work with from my main system. Be aware that you can delete all your files if you don't umount it before deleting the whole chroot.

```
cat << EOF | sudo tee -a /etc/fstab
/home /mnt/ssd/sgd_chroot_buster_amd64/home ext4 bind 0 0
EOF
```

Then you need to mount all these mounts with:
```
mount -a
```
### Custom your Buster Chroot

In order to enter into the Chroot you need to do:

```
chroot /mnt/ssd/sgd_chroot_buster_amd64/ /bin/bash
```

Once inside the chroot:

  I add my usual user (which happens to be 1000 UID so that's ok with home files)
```
adduser myuser
```
  I setup a password for it.
```
passwd myuser
```
  I make sure that resolv.conf has a working nameserver
```
nano /etc/resolv.conf
```
  I install sudo package
```
apt-get install sudo
```
  I setup sudo so that my normal user has sudo permissions
```
sudoedit /etc/sudoers
myuser  ALL=(ALL:ALL) ALL
```
  I modify the chroot name so that I am aware of it
```
nano /etc/debian_chroot
```
I write: SG2D_CHROOT inside it

  Take rid of perl warning messages:
```
apt-get install debconf
apt-get install locales
nano /etc/locale.gen
Uncomment # en_US.UTF-8 UTF-8 line and save
locale-gen
```

If I am inside the chroot and I want to work as my new normal user I can run:
```
su - myuser
```

## Super Grub2 Disk Buster Chroot Build

As explained in Super Grub2 Disk Buster Chroot you need to enter in the chroot thanks to:
```
chroot /mnt/ssd/sgd_chroot_buster_amd64/ /bin/bash
```
Alternatively you might decide not to do it.

We probably need to install git package
```
apt-get install git
```
And other packages:
```
apt-get install gettext unifont xorriso mtools zip rsync
```
Additional packages (needed only if you want to run grub-build-004-make-check ): TODO.

You also need to configure src entries on your sources.list file and then run:
```
apt-get -y build-dep grub2
```

Now we are going to work as a normal user

```
su - myuser
```

so that we can work from our development directory.

```
mkdir -p ~/gnu/sgd/supergrub2_upstream
cd  ~/gnu/sgd/supergrub2_upstream
```

Now we are going to get Super Grub2 Disk source code.
```
git clone https://github.com/supergrub/supergrub.git
```
Although a final user can use their own grub thanks to `supergrub-build-config` file we recommend you to build grub yourself thanks to super grub disk build script.

First of all we make sure we are in super grub disk directory.
```
cd supergrub
```
Then we will fetch, build grub and install grub in a custom directory (this will not affect your system or chroot grub installation).
```
./grub-build-001-prepare-build
./grub-build-002-clean-and-update
./grub-build-003-build-all
./grub-build-004-make-check (optional)
./grub-build-005-install-all
```
Finally we can just build the hybrid version for SG2D:
```
./supergrub-mkrescue
```
If everything went well and you did not miss any of the former steps you will get inside releases directory, among others, these files:
```
super_grub2_disk_hybrid_2.00s1-beta6.iso
super_grub2_disk_hybrid_2.00s1-beta6.iso.md5
super_grub2_disk_hybrid_2.00s1-beta6.iso.sha1
super_grub2_disk_hybrid_2.00s1-beta6.iso.sha256
```
which their filename might vary depending on the current Super Grub2 Disk version.

Or we can build all the SG2D releases thanks to:
```
./supergrub-meta-mkrescue
```
In this case the files will be found at `releases/` directory.

## Super Grub2 Disk team - Old release procedure

```
./grub-build-001-prepare-build
./grub-build-002-clean-and-update
./grub-build-003-build-all
./grub-build-005-install-all
./supergrub-official-release
git tag -a newversion -m "newversion"
```
and
```
./supergrub-release-changes 2.02s7
```

where 2.02s7 is the previous version (git tag) to the current one you are releasing.

Useful files for helping with the html release piece of news will be found at `news-releases` directory.

## Super Grub2 Disk team - New release procedure

### Automatic build

- Build 2.06s3-beta4 tag
- Previous version: 2.06s2-beta1

```
mkdir ~/gnu/sgd/supergrub2-build-2.06s3-beta4-official-release-build
cd ~/gnu/sgd/supergrub2-build-2.06s3-beta4-official-release-build

git clone https://github.com/supergrub/supergrub.git -b 2.06s3-beta4
cd supergrub
```

```
docker build \
  --build-arg SGD_BUILDER_UID=$(id -u) \
  --build-arg SGD_BUILDER_GID=$(id -g) \
  --tag supergrub-automatic-builder . \
  -f automatic-builder.Dockerfile
```

```
docker run \
  -it \
  --privileged \
  --env PREVIOUS_VERSION=2.06s2-beta1 \
  --env SGD_BUILDER_UID=$(id -u) \
  --env SGD_BUILDER_GID=$(id -g) \
  -v /dev:/dev \
  -v $(pwd):/supergrub2-repo:ro \
  -v $(pwd)/releases:/supergrub2-build/releases:rw \
  -v $(pwd)/news-releases:/supergrub2-build/news-releases:rw \
  -v $(pwd)/secureboot-binaries:/supergrub2-build/secureboot-binaries:rw \
  -v $(pwd)/secureboot.d/sha256sums:/supergrub2-build/secureboot.d/sha256sums:rw \
  supergrub-automatic-builder:latest
```

### Useful output

At `~/gnu/sgd/supergrub2-build-2.06s3-beta4-official-release-build/supergrub` path we will find:

- releases/ : Binaries to upload
- news-releases/changes.2.06s3-beta4.html : Changes from latest tag.
- news-releases/downloads.2.06s3-beta4.html : Download links with checksums for all of the binaries

# Alternative Super Grub2 Disk Build

This non recommended alternative build let's you use your system own grub installation instead of Super Grub2 Disk one.

Just use the same instructions as: "[Super Grub2 Disk Buster Chroot Build](#Super Grub2 Disk Buster Chroot Build)" section however:

- Do not run `grub-build-*` commands
- Rename `supergrub-build-config.example` file to `supergrub-build-config` .
- Edit `supergrub-build-config` to suit your grub installation if needed.
- Just use `supergrub-mkrescue` command which might build an `x86`, `amd64_efi`, `hybrid` (or another platform) depending your installed system grub.
- Do not use `supergrub-meta-mkrescue` because it does not work with your system grub.
