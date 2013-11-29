# Copyright (C) 2011-2012 Freescale Semiconductor
# Released under the MIT license (see COPYING.MIT for the terms)

PV = "3.9rc7+git${SRCREV}"
PR = "${INC_PR}.8"

require linux-dmo.inc

SRC_URI = "git://git@emb.data-modul.com/development/linux;protocol=ssh \
           file://defconfig \
           file://fsl_otp-compile-problem.patch \
"
S = "${WORKDIR}/git"

KERNEL_PRIORITY = "10000"

COMPATIBLE_MACHINE = "(mx6)"

SRCREV = "4176b247bff3179df1d037d4b95fcf69ee26662f"

