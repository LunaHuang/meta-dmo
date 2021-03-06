# Class to generate the sdcard image.

HOMEPAGE = "https://emb.data-modul.com"

inherit image_types

# we need generating the rootfs to every time
do_rootfs[nostamp] = "1"

SDCARD_SIZE = "3858432"
SDCARD_WITH_HOMEFS    = "${IMAGE_NAME}.with-homefs.sdcard2"
SDCARD_WITHOUT_HOMEFS = "${IMAGE_NAME}.without-homefs.sdcard2"
SDCARD_WITHOUT_OVERLAY = "${IMAGE_NAME}.without-overlayfs.sdcard2"
SDCARD_WITH_HOMEFS_FULL    = "${DEPLOY_DIR_IMAGE}/${SDCARD_WITH_HOMEFS}"
SDCARD_WITHOUT_HOMEFS_FULL = "${DEPLOY_DIR_IMAGE}/${SDCARD_WITHOUT_HOMEFS}"
SDCARD_WITHOUT_OVERLAY_FULL = "${DEPLOY_DIR_IMAGE}/${SDCARD_WITHOUT_OVERLAY}"
SDCARD_LINK_WITH_HOMEFS    = "${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.with-homefs.sdcard2"
SDCARD_LINK_WITHOUT_HOMEFS = "${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.without-homefs.sdcard2"
SDCARD_LINK_WITHOUT_OVERLAY = "${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.without-overlayfs.sdcard2"

IMAGE_DEPENDS_dmosdcard = "parted-native dosfstools-native mtools-native \
                        virtual/kernel:do_deploy ${IMAGE_BOOTLOADER}:do_deploy"

IMAGE_CMD_dmosdcard () {
    if [ -z "${SDCARD_ROOTFS}" ]; then
            bberror "SDCARD_ROOTFS is undefined. To use sdcard image from Data-Moudl BSP it needs to be defined."
            exit 1
    fi

    # create SDCARD
    bbnote "creating sdcard"
    truncate -s $(expr ${SDCARD_SIZE} \* 1024) ${SDCARD_WITH_HOMEFS_FULL}

    # ... and partition this sdcard
    # 0000MB - 0001MB - Bootspace (unpartitioned)
    # 0001MB - 0010MB - Kernelspace (fat32)
    # 0010MB - 1000MB - RootFS (ext3)
    # 1000MB - 2000M  - HomeFS (ext3)
    parted -s ${SDCARD_WITH_HOMEFS_FULL} mklabel msdos
    parted -s ${SDCARD_WITH_HOMEFS_FULL} unit KiB mkpart primary fat32    1024   53248
    parted -s ${SDCARD_WITH_HOMEFS_FULL} unit KiB mkpart primary         53248 2936832
    parted -s ${SDCARD_WITH_HOMEFS_FULL} unit KiB mkpart primary       2936832 3653632
    parted -s ${SDCARD_WITH_HOMEFS_FULL} unit KiB mkpart primary       3653632 3858431
    parted -s ${SDCARD_WITH_HOMEFS_FULL} print

    # put barebox to image
    dd if=${DEPLOY_DIR_IMAGE}/barebox-${MACHINE}.bin of=${SDCARD_WITH_HOMEFS_FULL} conv=notrunc seek=1 skip=1 bs=512

    # put kernel to image (shameless copied from meta-fsl-arm)
    [ -e ${WORKDIR}/boot.img ] && rm ${WORKDIR}/boot.img
    BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDCARD_WITH_HOMEFS_FULL} unit b print | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 1024 }')
    mkfs.vfat -n "${BOOTDD_VOLUME_ID}" -S 512 -C ${WORKDIR}/boot.img $BOOT_BLOCKS
    mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${MACHINE}.bin ::/${KERNEL_IMAGETYPE}
    # copy the devicetrees in kernel image
    for dtb in ${KERNEL_DEVICETREE}
    do
        mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${dtb} ::/
    done
    mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${DEFAULT_KERNEL_DEVICETREE} ::/oftree
    if [ ! -z "${INITRAMFS_IMAGE}" ]; then
        mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${INITRAMFS_IMAGE}-${MACHINE}.cpio.gz ::/initramfs
    fi

    # Creat the overlay partition
    [ -e ${WORKDIR}/overlay.img ] && rm ${WORKDIR}/overlay.img
    truncate -s $(expr 1024 \* 716799) ${WORKDIR}/overlay.img
    mkfs.ext4 -F ${WORKDIR}/overlay.img
    
    # Burn Partition
    dd if=${WORKDIR}/boot.img    of=${SDCARD_WITH_HOMEFS_FULL} conv=notrunc seek=1 bs=$(expr 1024    \* 1024) && sync && sync
    dd if=${SDCARD_ROOTFS}       of=${SDCARD_WITH_HOMEFS_FULL} conv=notrunc seek=1 bs=$(expr 53248   \* 1024) && sync && sync
    dd if=${WORKDIR}/overlay.img of=${SDCARD_WITH_HOMEFS_FULL} conv=notrunc seek=1 bs=$(expr 2936832 \* 1024) && sync && sync
    dd if=${HOMEFS_IMAGE_FULL}        of=${SDCARD_WITH_HOMEFS_FULL} conv=notrunc seek=1 bs=$(expr 3653632 \* 1024) && sync && sync

    # crop image to get one without homefs, but with same partition table
    cp ${SDCARD_WITH_HOMEFS_FULL} ${SDCARD_WITHOUT_HOMEFS_FULL}
    truncate -s $(expr 1024 \* 3653632) ${SDCARD_WITHOUT_HOMEFS_FULL}

    # crop image to get one without overlay and homefs, but with same partition table
    cp ${SDCARD_WITH_HOMEFS_FULL} ${SDCARD_WITHOUT_OVERLAY_FULL}
    truncate -s $(expr 1024 \* 2936832) ${SDCARD_WITHOUT_OVERLAY_FULL}

    rm -f ${SDCARD_LINK_WITH_HOMEFS}
    ln -s ${SDCARD_WITH_HOMEFS} ${SDCARD_LINK_WITH_HOMEFS}
    rm -f ${SDCARD_LINK_WITHOUT_HOMEFS}
    ln -s ${SDCARD_WITHOUT_HOMEFS} ${SDCARD_LINK_WITHOUT_HOMEFS}
    rm -f ${SDCARD_LINK_WITHOUT_OVERLAY}
    ln -s ${SDCARD_WITHOUT_OVERLAY} ${SDCARD_LINK_WITHOUT_OVERLAY}
    rm -f ${HOMEFS_LINK_IMAGE}
    ln -s ${HOMEFS_IMAGE} ${HOMEFS_LINK_IMAGE}
}

