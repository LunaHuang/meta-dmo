require dmo-image.inc

# hardware independent packages
IMAGE_INSTALL = " \
    bash \
    blanking \
    bluez-hcidump \
    bluez5 \
    canutils \
    coreutils \
    dietsplash \
    dmo-gst-videoscripts \
    e2fsprogs-e2fsck \
    e2fsprogs-mke2fs \
    e2fsprogs-tune2fs \
    ethtool \
    fb-test \
    gstreamer1.0 \
    gstreamer1.0-plugins-bad-meta \
    gstreamer1.0-plugins-base-meta \
    gstreamer1.0-plugins-good-meta \
    i2c-tools \
    icu \
    iperf \
    iproute2 \
    iputils \
    iw \
    kernel-modules \
    kmod \
    linux-firmware \
    mtd-utils \
    mtools \
    nfs-utils \
    nfs-utils-client \
    obexd \
    openobex \
    openssh \
    packagegroup-core-full-cmdline \
    pciutils \
    powertop \
    procps \
    root-user-homedir \
    systemd-vconsole-setup \
    strace \
    sudo \
    tslib-conf \
    tslib-calibrate \
    tslib-tests \
    udev-extraconf \
    usbutils \
    util-linux \
    wget \
    wireless-tools \
    wpa-supplicant \
    ${ROOTFS_PKGMANAGE_BOOTSTRAP} \
    ${CORE_IMAGE_EXTRA_INSTALL} \
"
IMAGE_INSTALL_append_dmo-x11 = " \
    mesa-demos \
    packagegroup-xfce-base \
    unclutter \
    xdg-utils \
    xf86-input-evdev \
    xf86-video-fbdev \
    xhost \
    xinput-calibrator \
    xmodmap \
    xrdb \
    xserver-nodm-init \
    xserver-xorg \
    xserver-xorg-extension-dbe \
    xserver-xorg-extension-extmod \
    xset \
"
IMAGE_INSTALL_append_dmo-qt = " \
    cinematicexperience \
    qupzilla \
    qt3d \
    qtbase \
    qtbase-examples \
    qtbase-fonts \
    qtbase-fonts-pfa \
    qtbase-fonts-pfb \
    qtbase-fonts-qpf \
    qtbase-fonts-ttf-dejavu \
    qtbase-fonts-ttf-vera \
    qtbase-mkspecs \
    qtbase-plugins \
    qtbase-tools \
    qtdeclarative \
    qtdeclarative-examples \
    qtdeclarative-mkspecs \
    qtdeclarative-plugins \
    qtdeclarative-qmlplugins \
    qtdeclarative-tools \
    qtmultimedia \
    qtmultimedia-examples \
    qtmultimedia-mkspecs \
    qtmultimedia-plugins \
    qtmultimedia-qmlplugins \
"
# Hardware depend packages
IMAGE_INSTALL_append_mx6q = " \
    firmware-imx-vpu-imx6q \
"
IMAGE_INSTALL_append_mx6dl = " \
    firmware-imx-vpu-imx6d \
"
IMAGE_INSTALL_append_mx6 = " \
    imx-gpu-viv \
    imx-gpu-viv-demos \
"
IMAGE_INSTALL_append_mx6_dmo-x11 = " \
    firefox \
    xf86-video-imxfb-vivante \
"
IMAGE_INSTALL_append_dmo-edm-comb_dmo-x11 = " \
    alsa-utils \
    gstreamer-vaapi-1.0 \
    intel-microcode \
    libva-intel-driver \
    mesa-megadriver \
    xf86-video-intel \
    xserver-xorg-extension-glx \
"
IMAGE_INSTALL_append_dmo-edm-comb = " \
    dmec-driver \
    eapi-lib \
    eapi-app \
"

