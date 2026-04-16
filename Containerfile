# 1. THE BASE (Bazzite Nvidia)
FROM ghcr.io/ublue-os/bazzite-nvidia:latest

# 2. THE REPOS (Cloudflare & Zen Browser)
# We use the Sneexy COPR for a true native Zen Browser experience.
RUN curl -Lo /etc/yum.repos.d/cloudflare-warp.repo https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo && \
    curl -Lo /etc/yum.repos.d/_copr_sneexy-zen-browser.repo https://copr.fedorainfracloud.org/coprs/sneexy/zen-browser/repo/fedora-43/sneexy-zen-browser-fedora-43.repo

# 3. THE DEBLOAT
# We remove the core launchers and the Waydroid dependency loop in one go.
RUN rpm-ostree override remove \
    steam \
    lutris \
    waydroid \
    waydroid-selinux

# 4. NATIVE INSTALL (The Tank Core)
# Baked directly into the OS. No OnlyOffice here to cause errors.
RUN rpm-ostree install \
    alacritty \
    kvantum \
    cloudflare-warp \
    qbittorrent \
    zen-browser

# 5. PORTPROTON PREP (Repack Essentials)
# These are the native libraries needed for FitGirl installers to run smoothly.
RUN rpm-ostree install wine-core wine-common p7zip p7zip-plugins libavcodec-freeworld

# 6. SECURITY: Trust your signature
COPY cosign.pub /etc/pki/containers/aniketian.pub
