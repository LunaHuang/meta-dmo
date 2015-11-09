# This is the basic distro for our systems. 
# It's planed to use this inc file as base for all distros, including customer
# specific version.
require conf/distro/poky.conf

# Set systemd as init system
DISTRO_FEATURES_append = " systemd "
VIRTUAL-RUNTIME_init_manager = " systemd "
VIRTUAL-RUNTIME_initscripts = ""

# disable this BACKFILL distro features
# you don't know what BACKFILL is? *tz* look here: http://patches.openembedded.org/patch/21849/
DISTRO_FEATURES_BACKFILL_CONSIDERED += " pulseaudio sysvinit "

# some license things here
LICENSE_FLAGS_WHITELIST += "commercial_libav commercial_x264"

# We always want to use package management
IMAGE_FEATURES += " package-management "

# Data-Modul FTP-Server
DMOFTP = "ftp://Public_EMB@ftp.data-modul.com"

# Ship all kernel modules by default
MACHINE_EXTRA_RRECOMMENDS = " kernel-modules"

# Remove files from comercial license recipes
#DMO_REMOVE_FILES_FROM_COMMERCIAL_RECIPES = "1"

PREFERRED_PROVIDER_jpeg = "jpeg"
PREFERRED_PROVIDER_jpeg-native = "jpeg-native"

PREFERRED_VERSION_kern-tools-native_git = "0.2+git83f468ab8ef748a8880cba7d26779c35abfcc0bf"

# We disable the vivante kernel modul, as we are using our own kernel
MACHINE_USES_VIVANTE_KERNEL_DRIVER_MODULE = "0"
