FROM debian:11.3

ARG SGD_BUILDER_UID
ARG SGD_BUILDER_GID

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo '\
deb-src http://deb.debian.org/debian bullseye main\n\
deb-src http://security.debian.org/debian-security bullseye-security main\n\
deb-src http://deb.debian.org/debian bullseye-updates main\n\
' > /etc/apt/sources.list.d/debian-sources.list

RUN apt-get -y update && \
    apt-get -y install sudo \
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

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

RUN apt-get -y install grub-common

RUN apt-get -y build-dep grub2

RUN echo "sgdbuilder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sgdbuilder-sudo
RUN groupadd -g ${SGD_BUILDER_GID} sgdbuilder
RUN useradd -u ${SGD_BUILDER_UID} sgdbuilder -g sgdbuilder
ADD --chown=${SGD_BUILDER_UID}:${SGD_BUILDER_GID} . /supergrub2-repo
RUN mkdir /supergrub2-build
RUN chown ${SGD_BUILDER_UID}:${SGD_BUILDER_GID} /supergrub2-build

USER sgdbuilder
RUN git clone /supergrub2-repo /supergrub2-build
WORKDIR /supergrub2-build
