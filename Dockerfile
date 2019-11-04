FROM archlinux/base
ARG ARCH

RUN pacman -Syuq base-devel --needed --noconfirm && rm -r /var/cache/pacman/pkg
RUN useradd -M builduser && \
    echo "builduser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builduser && \
    echo 'CFLAGS="-march='$ARCH' -O3 -pipe -fno-plt -fomit-frame-pointer -fstack-protector-strong --param=ssp-buffer-size=4 -ffunction-sections -fdata-sections"' >> /etc/makepkg.conf && \
    echo 'CXXFLAGS="$CFLAGS"' >> /etc/makepkg.conf && \
    echo 'LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now,--gc-sections"' >> /etc/makepkg.conf && \
    echo 'MAKEFLAGS="-j2"' >> /etc/makepkg.conf && \
    echo 'PKGDEST="/build"' >> /etc/makepkg.conf && \
    echo 'PKGEXT="-'$ARCH'.pkg.tar.zst"' >> /etc/makepkg.conf

COPY --chown=builduser . /trunk/

USER builduser
WORKDIR /trunk
VOLUME /build
