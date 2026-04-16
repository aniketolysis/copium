# Start from Bazzite KDE with Nvidia drivers
FROM ghcr.io/ublue-os/bazzite-nvidia:latest

# 1. Add Cloudflare WARP Repository
RUN curl -Lo /etc/yum.repos.d/cloudflare-warp.repo https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo

# 2. Rip out the Steam/Lutris/Waydroid (Sunshine is already gone)
RUN rpm-ostree override remove \
    steam \
    lutris \
    waydroid

# 3. Layer the core system tools (baked into the OS)
RUN rpm-ostree install \
    alacritty \
    kvantum \
    cloudflare-warp

# 4. Install your optimized Flatpaks
RUN flatpak install --system -y flathub \
    org.qbittorrent.qBittorrent \
    org.onlyoffice.desktopeditors \
    io.github.zen_browser.zen \
    ru.linux_gaming.PortProton

# This tells the OS to trust your signature
COPY cosign.pub /etc/pki/containers/aniketian.pub
