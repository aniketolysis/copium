# 1. THE BASE (Bazzite Nvidia)
# Keeps the proprietary Nvidia drivers baked in for the RTX 3050.
FROM ghcr.io/ublue-os/bazzite-nvidia:latest

# 2. THE REPOS (Cloudflare & Zen Browser)
# FIX: Dynamically fetch the correct Fedora version for the COPR repo using $(rpm -E %fedora).
# This prevents version mismatches and broken dependencies.
RUN curl -Lo /etc/yum.repos.d/cloudflare-warp.repo https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo && \
    curl -Lo /etc/yum.repos.d/_copr_sneexy-zen-browser.repo https://copr.fedorainfracloud.org/coprs/sneexy/zen-browser/repo/fedora-$(rpm -E %fedora)/sneexy-zen-browser-fedora-$(rpm -E %fedora).repo

# 3. THE DEBLOAT
RUN rpm-ostree override remove \
    steam \
    lutris \
    waydroid \
    waydroid-selinux

# 4 & 5. NATIVE INSTALL & PORTPROTON PREP (Combined)
# FIX: Merged all installs into a single RUN command. This creates one clean ostree commit
# instead of multiple fragmented layers, drastically speeding up the build.
# Having these native libraries will help smooth out heavy FitGirl extractions on the Ryzen 5800H.
RUN rpm-ostree install \
    alacritty \
    kvantum \
    cloudflare-warp \
    qbittorrent \
    zen-browser \
    wine-core \
    wine-common \
    p7zip \
    p7zip-plugins \
    libavcodec-freeworld \
    && rpm-ostree cleanup -m

# 6. SECURITY: Trust your signature
COPY cosign.pub /etc/pki/containers/aniketian.pub
