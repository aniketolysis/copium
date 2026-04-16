# 1. THE BASE (Bazzite Nvidia)
FROM ghcr.io/ublue-os/bazzite-nvidia:latest

# 2. ADD NATIVE REPOS
# We write the OnlyOffice repo manually to avoid "dead link" errors.
RUN curl -Lo /etc/yum.repos.d/cloudflare-warp.repo https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo && \
    printf "[onlyoffice]\nname=onlyoffice\nbaseurl=https://download.onlyoffice.com/repo/centos/main/noarch/\ngpgcheck=1\nenabled=1\ngpgkey=https://download.onlyoffice.com/repo/centos/main/noarch/onlyoffice.pub" > /etc/yum.repos.d/onlyoffice.repo

# 3. THE DEBLOAT (The Clean Sweep)
# Removing Steam, Lutris, and the entire Waydroid stack together.
RUN rpm-ostree override remove \
    steam \
    lutris \
    waydroid \
    waydroid-selinux

# 4. NATIVE INSTALL (Baked directly into the OS)
# These will be real, native RPM packages. No sandboxes.
RUN rpm-ostree install \
    alacritty \
    kvantum \
    cloudflare-warp \
    qbittorrent \
    

# 5. NATIVE ZEN BROWSER (The "Manual Native" Way)
# We download the engine and link it to your system so 'zen-browser' works in terminal.
RUN curl -L https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.bz2 | tar -xj -C /opt/ && \
    ln -s /opt/zen/zen /usr/bin/zen-browser

# 6. SECURITY: Trust your signature
COPY cosign.pub /etc/pki/containers/aniketian.pub
