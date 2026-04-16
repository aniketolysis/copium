# 1. THE BASE (Fedora 43 / Bazzite 2026)
FROM ghcr.io/ublue-os/bazzite-nvidia:latest

# 2. ADD REPOS (Cloudflare & OnlyOffice)
RUN curl -Lo /etc/yum.repos.d/cloudflare-warp.repo https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo && \
    curl -Lo /etc/yum.repos.d/onlyoffice.repo https://download.onlyoffice.com/repo/fedora/main/noarch/onlyoffice.repo

# 3. THE DEBLOAT (The Fix: Added waydroid-selinux)
# This removes Steam, Lutris, and the entire Waydroid stack.
RUN rpm-ostree override remove \
    steam \
    lutris \
    waydroid \
    waydroid-selinux

# 4. NATIVE INSTALL (Baked directly into the OS layer)
RUN rpm-ostree install \
    alacritty \
    kvantum \
    cloudflare-warp \
    qbittorrent \
    onlyoffice-desktopeditors

# 5. NATIVE ZEN BROWSER (Manual Install to /opt)
# We download the latest tarball, unpack it to /opt, and link it to your system path.
RUN curl -L https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.bz2 | tar -xj -C /opt/ && \
    ln -s /opt/zen/zen /usr/bin/zen-browser

# 6. SECURITY: Tells the OS to trust your local image
COPY cosign.pub /etc/pki/containers/aniketian.pub
